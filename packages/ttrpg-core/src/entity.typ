// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// The generic entity: a flat dictionary with a few fields every system
// shares. System fields (hp, tier, ...) sit next to them at the top level.

#import "validate.typ": field, validate

/// Fields every feature has. Systems add their own (e.g. `kind`).
#let feature-schema = (
  name: field(str, required: true),
  body: field(str, content, required: true),
  // Features that belong to this one, e.g. the forms a feature introduces
  // ("... gain the following features:"), in order.
  features: field(array, items: dictionary),
)

/// Fields every entity has. A system schema is merged on top of this, so a
/// system may tighten a rule, e.g. give `features` a richer `items` schema.
#let base-schema = (
  id: field(str, required: true),
  name: field(str, required: true),
  kind: field(str, required: true),
  tags: field(array, default: (), items: str, unique: true),
  features: field(array, default: (), items: feature-schema, unique: "name"),
  flags: field(dictionary, default: (:)),
)

/// The complete schema for a system schema: base fields plus system fields.
#let full-schema(schema) = base-schema + schema

/// A named feature with a prose body:
/// `feature("Cheap Shot", kind: "action")[...]`.
#let feature(name, body, ..fields) = (name: name, body: body) + fields.named()

/// Builds and validates an entity of `kind`. Named arguments set to `none`
/// count as not given, so system constructors can declare every field in
/// their signature (for editor completion) and pass them all through:
///
/// ```typ
/// #let creature(id: none, name: none, hp: none, ..unknown) = entity(
///   "creature", creature-schema, id: id, name: name, hp: hp, ..unknown)
/// ```
/// Unknown arguments land in `..unknown` and are reported by validation.
#let entity(kind, schema, ..args) = {
  if args.pos().len() > 0 {
    panic(kind + ": unexpected positional argument " + repr(args.pos().first()) + "; fields are named, e.g. `name: \"...\"`")
  }
  let fields = (:)
  for (key, value) in args.named() {
    if value != none { fields.insert(key, value) }
  }
  let label = kind + " " + repr(fields.at("id", default: "(no id)"))
  if "kind" in fields and fields.kind != kind {
    panic(label + ": `kind` is set by the constructor and cannot be changed")
  }
  validate(label, full-schema(schema), fields + (kind: kind))
}
