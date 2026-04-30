/**
 * ItemResourceType augmentation — only available in full OpenAI package.
 * This file is imported by the swagger tspconfig but NOT by sdk-csharp tspconfig
 * because the client-emitters view doesn't expose OpenAI.ItemResourceType.
 */
import "@azure-tools/typespec-azure-core/experimental";
import "./responses/models.tsp";

using Azure.Core.Experimental;

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental copyVariants"
namespace Azure.AI.Projects {
  @@copyVariants(OpenAI.ItemResourceType, _AgentItemType);
}
