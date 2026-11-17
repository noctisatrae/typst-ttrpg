// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Schema validation. A schema is a dictionary of field name -> rule, where
// rules are built with `field`. Validation collects every problem and
// reports them in one error that names the entity and each field.

/// Describes one field of a schema.
///
/// - types: accepted Typst types, e.g. `field(int)` or `field(str, content)`.
/// - required: the field must be given (after defaults are applied).
/// - default: value used when the field is not given.
/// - one-of: array of allowed values.
/// - items: for arrays, the type of each item, or a schema each item must match.
/// - unique: for arrays, `true` (items unique) or a key, e.g. `"name"`.
/// - keys: for dictionaries, a schema the dictionary must match.
/// - check: `(value, fields) => message or none`, for rules that involve
///   other fields, e.g. "required when `type` is Horde".
#let field(
  ..types,
  required: false,
  default: none,
  one-of: none,
  items: none,
  unique: none,
  keys: none,
  check: none,
) = (
  types: types.pos(),
  required: required,
  default: default,
  one-of: one-of,
  items: items,
  unique: unique,
  keys: keys,
  check: check,
)

/// Edit distance between two strings, used for "did you mean" hints.
#let distance(a, b) = {
  let a = a.clusters()
  let b = b.clusters()
  let prev = range(b.len() + 1)
  for i in range(a.len()) {
    let cur = (i + 1,)
    for j in range(b.len()) {
      let cost = if a.at(i) == b.at(j) { 0 } else { 1 }
      cur.push(calc.min(cur.at(j) + 1, prev.at(j + 1) + 1, prev.at(j) + cost))
    }
    prev = cur
  }
  prev.last()
}

/// The closest name in `known`, or none if nothing is close enough.
#let suggest(name, known) = {
  if known.len() == 0 { return none }
  let score(k) = distance(lower(name), lower(k))
  let best = known.sorted(key: score).first()
  if score(best) <= 2 { best }
}

#let type-name(t) = if t == int { "integer" } else if t == str { "string" } else if t == type(none) { "none" } else { str(t) }

#let types-name(types) = types.map(type-name).join(", ", last: " or ")

#let check-type(path, value, types) = {
  if types.len() == 0 or type(value) in types { () } else {
    ("field `" + path + "` must be " + types-name(types) + ", got " + type-name(type(value)) + " " + repr(value),)
  }
}

/// Checks `fields` against `schema`.
/// Returns `(fields, errors, unknown)`: the fields with defaults applied, a
/// list of messages, and whether any field was unknown.
#let check(schema, fields, prefix: "") = {
  let errors = ()
  let hinted = ()
  let unknown = false
  for (key, value) in fields {
    let path = prefix + key
    if key not in schema {
      unknown = true
      let hint = suggest(key, schema.keys())
      if hint != none { hinted.push(hint) }
      errors.push("unknown field `" + path + "`" + if hint != none { " (did you mean `" + prefix + hint + "`?)" })
      continue
    }
    let rule = schema.at(key)
    let type-errors = check-type(path, value, rule.types)
    if type-errors.len() > 0 {
      errors += type-errors
      continue
    }
    if rule.one-of != none and value not in rule.one-of {
      errors.push("field `" + path + "` must be one of " + rule.one-of.map(repr).join(", ") + ", got " + repr(value))
    }
    if type(value) == array and rule.items != none {
      for (i, item) in value.enumerate() {
        let item-path = path + "[" + str(i) + "]"
        if type(rule.items) == dictionary {
          if type(item) != dictionary {
            errors.push("field `" + item-path + "` must be a dictionary, got " + type-name(type(item)) + " " + repr(item))
          } else {
            let label = if "name" in item { " (" + repr(item.name) + ")" } else { "" }
            let (_, item-errors, item-unknown) = check(rule.items, item, prefix: item-path + label + ".")
            errors += item-errors
            unknown = unknown or item-unknown
          }
        } else {
          errors += check-type(item-path, item, (rule.items,))
        }
      }
    }
    if type(value) == dictionary and rule.keys != none {
      let (sub, sub-errors, sub-unknown) = check(rule.keys, value, prefix: path + ".")
      fields.insert(key, sub)
      errors += sub-errors
      unknown = unknown or sub-unknown
    }
    if rule.check != none {
      let message = (rule.check)(value, fields)
      if message != none { errors.push(message) }
    }
    if type(value) == array and rule.unique != none {
      let key-of(item) = if rule.unique == true { item } else if type(item) == dictionary { item.at(rule.unique, default: none) } else { item }
      let seen = ()
      for item in value {
        let k = key-of(item)
        if k in seen {
          errors.push("field `" + path + "` has " + repr(k) + " more than once")
        }
        seen.push(k)
      }
    }
  }
  for (key, rule) in schema {
    if key not in fields and rule.default != none {
      fields.insert(key, rule.default)
    }
    if rule.required and key not in fields and key not in hinted {
      errors.push("missing required field `" + prefix + key + "`")
    }
  }
  (fields, errors, unknown)
}

/// Panics with every error in one message, or does nothing if there are none.
/// `label` names the entity, e.g. `adversary "bandit"`.
#let report(label, errors, schema: none, unknown: false) = {
  if errors.len() == 0 { return }
  let count = str(errors.len()) + " problem" + if errors.len() > 1 { "s" }
  let message = (
    label + " has " + count + ":\n"
      + errors.map(e => "  - " + e).join("\n")
      + if unknown and schema != none { "\n  allowed fields: " + schema.keys().join(", ") }
  )
  panic(message)
}

/// Validates `fields` against `schema` and returns them with defaults
/// applied. Panics with a full report if anything is wrong.
#let validate(label, schema, fields) = {
  let (fields, errors, unknown) = check(schema, fields)
  report(label, errors, schema: schema, unknown: unknown)
  fields
}
