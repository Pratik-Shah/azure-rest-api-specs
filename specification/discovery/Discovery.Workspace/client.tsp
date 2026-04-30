/**
 * Client customizations for Discovery.Workspace SDK generation.
 *
 * This file addresses accessibility issues with vendored OpenAI/Foundry types
 * to ensure they are properly exposed in generated SDKs.
 *
 * Mirrors augmentations from Foundry's sdk-service-agents-contracts/client.tsp
 * so Discovery SDK output matches Foundry SDK conventions.
 */
import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.Core.Experimental;

// =============================================================================
// Client name customizations to avoid .NET naming conflicts (AZC0012/AZC0034)
// =============================================================================

// AZC0012: Only rename types with REAL CLR conflicts
// Task conflicts with System.Threading.Tasks.Task (used in every async file)
@@clientName(Microsoft.Discovery.Workspace.Task, "DiscoveryTask", "csharp");
// Operation conflicts with Azure.Operation (LRO base type)
@@clientName(Microsoft.Discovery.Workspace.Operation,
  "WorkspaceOperation",
  "csharp"
);

// =============================================================================
// OpenAI/Foundry type augmentations (mirroring Foundry sdk-service-agents-contracts/client.tsp)
// =============================================================================

// Mark the SSE events union for JSON usage so the emitter generates all event models
@@usage(OpenAI.CreateResponseStreamingResponse, Usage.json);

// Propagate "id" to base of output items (Foundry v1 pattern)
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental @@copyProperties for Foundry v1 output items"
@@copyProperties(OpenAI.OutputItem,
  {
    id?: string,
  }
);

// Propagate "sequence_number" to the base ResponseStreamEvent model (Foundry v1 addition)
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental @@copyProperties for Foundry v1 stream events"
@@copyProperties(OpenAI.ResponseStreamEvent,
  {
    sequence_number: integer,
  }
);

// Ensure ResponseStreamEvent base model and type discriminator are generated
@@usage(OpenAI.ResponseStreamEvent, Usage.output);
@@access(OpenAI.ResponseStreamEvent, Access.public);

// Ensure the OutputItem base is generated with proper accessibility
// OutputItem is server-returned only; specific subtypes (e.g. OutputItemCustomToolCallOutput)
// that need input usage are marked individually below.
@@usage(OpenAI.OutputItem, Usage.output);
@@access(OpenAI.OutputItem, Access.public);

// Ensure ItemResource (used in input items list) is generated
@@usage(OpenAI.ItemResource, Usage.json);

// Rename OpenAI.Response → ResponseObject to avoid Azure.Response conflict (matches Foundry)
@@clientName(OpenAI.Response, "ResponseObject");

// =============================================================================
// Remove created_by from specific output items to facilitate base union
// (matches Foundry sdk-service-agents-contracts/client.tsp lines 222-230)
// =============================================================================
#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Using experimental @@withoutOmittedProperties for Foundry v1 output items"
@@withoutOmittedProperties(OpenAI.OutputItemFunctionShellCallOutput,
  "created_by"
);
@@withoutOmittedProperties(OpenAI.OutputItemFunctionShellCall, "created_by");
@@withoutOmittedProperties(OpenAI.OutputItemCompactionBody, "created_by");
@@withoutOmittedProperties(OpenAI.OutputItemApplyPatchToolCallOutput,
  "created_by"
);
@@withoutOmittedProperties(OpenAI.OutputItemApplyPatchToolCall, "created_by");

// =============================================================================
// Force access/usage on agent request types to avoid naming suffix issues
// (matches Foundry sdk-service-agents-contracts/client.tsp lines 233-249)
// =============================================================================
@@access(Azure.AI.Projects.CreateAgentFromManifestRequest, Access.public);
@@usage(Azure.AI.Projects.CreateAgentFromManifestRequest, Usage.input);
@@access(Azure.AI.Projects.CreateAgentRequest, Access.public);
@@usage(Azure.AI.Projects.CreateAgentRequest, Usage.input);
@@access(Azure.AI.Projects.CreateAgentVersionFromManifestRequest, Access.public);
@@usage(Azure.AI.Projects.CreateAgentVersionFromManifestRequest, Usage.input);
@@access(Azure.AI.Projects.CreateAgentVersionRequest, Access.public);
@@usage(Azure.AI.Projects.CreateAgentVersionRequest, Usage.input);
@@access(OpenAI.ReasoningEffort, Access.public);
@@usage(OpenAI.ReasoningEffort, Usage.input);
@@access(Azure.AI.Projects.UpdateAgentFromManifestRequest, Access.public);
@@usage(Azure.AI.Projects.UpdateAgentFromManifestRequest, Usage.input);
@@access(Azure.AI.Projects.UpdateAgentRequest, Access.public);
@@usage(Azure.AI.Projects.UpdateAgentRequest, Usage.input);

@@access(OpenAI.OutputItemCustomToolCallOutput, Access.public);
@@usage(OpenAI.OutputItemCustomToolCallOutput, Usage.input | Usage.output);
