import "@typespec/versioning";
import "./.external-foundry/Azure.AI.Projects/_service.tsp";

using TypeSpec.Versioning;

@versioned(Versions)
namespace Microsoft.Discovery.Workspace;

@doc("The Microsoft.Discovery service versions.")
enum Versions {
  @doc("The 2026-02-01-preview version of the Microsoft.Discovery service data plane.")
  `2026-02-01-preview`,

  @doc("The 2026-06-01 stable version of the Microsoft.Discovery service data plane.")
  @useDependency(Azure.AI.Projects.Versions.v1)
  `2026-06-01`,
}
