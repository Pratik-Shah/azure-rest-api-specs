// SDK-specific client customizations for C# generation with client-emitters view.
// Provides compatibility shims for types that exist in src/ but not in views/client-emitters/.

namespace OpenAI {
  // ItemResourceType doesn't exist in client-emitters view (merged into ItemType).
  // Provide an alias so @@copyVariants in _foundry_v1_types.tsp resolves.
  alias ItemResourceType = ItemType;
}
