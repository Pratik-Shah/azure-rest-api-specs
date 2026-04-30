/**
 * Vendored from: specification/ai-foundry/data-plane/Foundry/src/common/models.tsp
 * Foundry version pin: v1 (as of 2025-07-25)
 *
 * TRIMMED: Only MetadataProperty aliases, ApiError/ApiErrorResponse, and OpenAIOperation template.
 * Removed: AssetBase, ResourceCreatedResponse, SseResponseOf, OpenAIOperationWithPreview.
 */
import "@azure-tools/typespec-azure-core/experimental";
import "@typespec/openapi";
import "@typespec/http";
import "@typespec/versioning";
import "./_service.tsp";
import "./_servicepatterns.tsp";

using Azure.Core.Experimental;
using Azure.Core.Traits;
using TypeSpec.OpenAPI;
using TypeSpec.Http;
using TypeSpec.Versioning;

namespace Azure.AI.Projects;

/** Error response for API failures. */
@error
model ApiErrorResponse {
  error: ApiError;
}

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental feature"
@@copyProperties(OpenAI.Error,
  {
    details?: OpenAI.Error[],
    additionalInfo?: Record<unknown>,
    debugInfo?: Record<unknown>,
  }
);

alias ApiError = OpenAI.Error;

alias MetadataPropertyForRequest = {
  /**
   * Set of 16 key-value pairs that can be attached to an object. This can be
   * useful for storing additional information about the object in a structured
   * format, and querying for objects via API or the dashboard.
   *
   * Keys are strings with a maximum length of 64 characters. Values are strings
   * with a maximum length of 512 characters.
   */
  @extension("x-oaiTypeLabel", "map")
  metadata?: Record<string>;
};

alias MetadataPropertyForResponse = {
  /**
   * Set of 16 key-value pairs that can be attached to an object. This can be
   * useful for storing additional information about the object in a structured
   * format, and querying for objects via API or the dashboard.
   *
   * Keys are strings with a maximum length of 64 characters. Values are strings
   * with a maximum length of 512 characters.
   */
  @extension("x-oaiTypeLabel", "map")
  metadata: Record<string> | null;
};

#suppress "@azure-tools/typespec-azure-core/operation-missing-api-version" "OpenAI-based operations are not conventionally versioned"
#suppress "@azure-tools/typespec-azure-core/use-standard-operations" "OpenAI-based operations are definitionally non-standard"
op OpenAIOperation<
  Params extends Reflection.Model,
  Response,
  ErrorResponse = ApiErrorResponse
>(...Params): Response | ErrorResponse;
