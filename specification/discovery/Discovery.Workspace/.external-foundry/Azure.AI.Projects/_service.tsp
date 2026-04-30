/**
 * Vendored from: specification/ai-foundry/data-plane/Foundry/src/common/service.tsp
 * Foundry version pin: v1 (as of 2025-07-25)
 *
 * TRIMMED: Removed @service, @server, @useAuth decorators.
 * Only namespace + Versions enum retained for cross-namespace versioning via @useDependency.
 */
import "@typespec/versioning";

using TypeSpec.Versioning;

@versioned(Versions)
namespace Azure.AI.Projects {
  @doc("Microsoft Foundry API versions")
  enum Versions {
    /**
     * An interim virtual API version representing backwards compatibility changes moving from public preview to general availability.
     */
    PuPr: "virtual-public-preview",

    @doc("Microsoft Foundry API version v1.")
    v1: "v1",
  }
}
