/**
 * Vendored from: specification/ai-foundry/data-plane/Foundry/src/common/custom-types.tsp
 * Foundry version pin: v1 (as of 2025-07-25)
 */
namespace OpenAI {
  scalar integer extends TypeSpec.int64;
  scalar numeric extends TypeSpec.float64;
}

namespace Azure.AI.Projects {
  scalar integer extends OpenAI.integer;
  scalar numeric extends OpenAI.numeric;
}
