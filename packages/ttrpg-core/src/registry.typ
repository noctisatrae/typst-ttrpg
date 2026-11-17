// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Document-wide registry of entities by id. Constructors cannot register
// (Typst functions have no side effects), so renderers place `register(e)`
// in the document. The same id with identical content counts once; the
// same id with different content is an error.

#let registry = state("ttrpg-core:registry", (:))

/// Content that records `entity` in the registry. Place it in the document.
#let register(entity) = {
  // Typst runs state updates lazily, so check in a context that reads the
  // state; this also makes the error fire even if nothing else reads it.
  context {
    let known = registry.get()
    if entity.id in known and known.at(entity.id) != entity {
      let other = known.at(entity.id)
      let keys = (other.keys() + entity.keys()).dedup()
      let differ = keys.filter(k => other.at(k, default: none) != entity.at(k, default: none))
      let message = (
        entity.kind + " " + repr(entity.id) + " is registered twice with different content\n"
          + "  fields that differ: " + differ.join(", ") + "\n"
          + "  give one of them its own id (e.g. with extend)"
      )
      panic(message)
    }
  }
  registry.update(known => {
    known.insert(entity.id, entity)
    known
  })
}

/// The entity registered under `id`, or `default`. Needs `context`.
#let lookup(id, default: none) = registry.get().at(id, default: default)

/// Every entity registered in the whole document, by id. Needs `context`.
#let registered() = registry.final()
