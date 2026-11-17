// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// `extend` builds a new, flat entity from a base. Scalars and dictionaries
// given to `extend` replace the base value. Lists must say what they do,
// with `add`, `remove`, `replace` or `all`; a plain list is an error,
// because readers disagree on whether it should append or replace.

#import "validate.typ": check, report
#import "entity.typ": full-schema

/// Appends items to a list: `tags: add("elite")`.
#let add(..items) = (ttrpg-op: "add", items: items.pos())

/// Removes items, by name for features or by value otherwise:
/// `features: remove("Flee")`.
#let remove(..keys) = (ttrpg-op: "remove", keys: keys.pos())

/// Changes one item in place, found by name (or by value). Named arguments
/// update fields of that item and a content block replaces its body:
/// `replace("Cheap Shot", kind: "reaction")[...]`. For plain values give the
/// new value: `replace("bandit", "outlaw")`.
#let replace(key, ..args) = (ttrpg-op: "replace", key: key, pos: args.pos(), named: args.named())

/// Replaces the whole list: `features: all(feature(...), ...)`.
#let all(..items) = (ttrpg-op: "all", items: items.pos())

#let is-op(value) = type(value) == dictionary and "ttrpg-op" in value

#let item-key(item) = if type(item) == dictionary and "name" in item { item.name } else { item }

#let usage(key) = (
  "  to change part of it: " + key + ": (add(...), replace(\"Name\")[...], remove(\"Name\"))\n"
    + "    to replace all of it: " + key + ": all(...)"
)

/// Applies list operations to `current`. Returns `(list, errors)`.
#let apply-ops(key, current, value) = {
  let ops = if is-op(value) { (value,) } else { value }
  if ops.any(op => not is-op(op)) {
    let what = if ops.all(op => not is-op(op)) { "a plain list" } else { "plain items mixed with add/remove/replace" }
    return (current, ("`" + key + "` is a list and got " + what + "; extend won't guess whether to add or replace.\n  " + usage(key),))
  }
  if ops.any(op => op.ttrpg-op == "all") and ops.len() > 1 {
    return (current, ("`" + key + "`: all(...) replaces the whole list and cannot be combined with other operations",))
  }
  let list = current
  let errors = ()
  for op in ops {
    let keys = list.map(item-key)
    if op.ttrpg-op == "all" {
      list = op.items
    } else if op.ttrpg-op == "add" {
      for item in op.items {
        if item-key(item) in keys {
          errors.push("`" + key + "` already has " + repr(item-key(item)) + "; use replace(" + repr(item-key(item)) + ", ...) to change it")
        } else {
          list.push(item)
        }
      }
    } else if op.ttrpg-op == "remove" {
      for k in op.keys {
        if k in keys {
          list = list.filter(item => item-key(item) != k)
        } else {
          errors.push("`" + key + "`: cannot remove " + repr(k) + ", not found; it has " + keys.map(repr).join(", "))
        }
      }
    } else if op.ttrpg-op == "replace" {
      let i = keys.position(k => k == op.key)
      if i == none {
        errors.push("`" + key + "`: cannot replace " + repr(op.key) + ", not found; it has " + keys.map(repr).join(", "))
        continue
      }
      let item = list.at(i)
      if type(item) == dictionary {
        if op.pos.len() > 1 {
          errors.push("`" + key + "`: replace(" + repr(op.key) + ") takes at most one body")
          continue
        }
        item += op.named
        if op.pos.len() == 1 { item.body = op.pos.first() }
      } else if op.pos.len() == 1 and op.named.len() == 0 {
        item = op.pos.first()
      } else {
        errors.push("`" + key + "`: replace(" + repr(op.key) + ", new) needs exactly one new value")
        continue
      }
      list.at(i) = item
    }
  }
  (list, errors)
}

/// Returns a new entity: `base` with `changes` applied, validated against the
/// schema registered for its kind in `schemas` (kind -> system schema).
/// Systems re-export it with their schemas bound:
/// `#let extend = core.extend.with(schemas: (adversary: adversary-schema))`.
///
/// The new entity needs its own `id`. `flags.extends` records the base id
/// for provenance; nothing should depend on it.
#let extend(base, schemas: (:), ..changes) = {
  if changes.pos().len() > 0 {
    panic("extend " + repr(base.id) + ": unexpected positional argument " + repr(changes.pos().first()) + "; changes are named, e.g. `hp: 6`")
  }
  let changes = changes.named()
  let label = base.kind + " " + repr(changes.at("id", default: "(no id)")) + " (extending " + repr(base.id) + ")"
  let errors = ()
  if "id" not in changes {
    errors.push("missing `id`; an extended entity needs its own id")
  } else if changes.id == base.id {
    errors.push("`id` must differ from the base id " + repr(base.id))
  }
  if "kind" in changes {
    errors.push("`kind` cannot be changed by extend")
  }
  let result = base
  for (key, value) in changes {
    if key == "kind" { continue }
    let current = base.at(key, default: none)
    if type(current) == array or is-op(value) or type(value) == array {
      let (list, op-errors) = apply-ops(key, if current == none { () } else { current }, value)
      result.insert(key, list)
      errors += op-errors
    } else {
      result.insert(key, value)
    }
  }
  if "flags" in result and type(result.flags) == dictionary {
    result.flags.insert("extends", base.id)
  }
  if base.kind not in schemas {
    errors.push("no schema known for kind " + repr(base.kind) + "; known: " + schemas.keys().map(repr).join(", "))
    report(label, errors)
  }
  let schema = full-schema(schemas.at(base.kind))
  let (fields, check-errors, unknown) = check(schema, result)
  report(label, errors + check-errors, schema: schema, unknown: unknown)
  fields
}
