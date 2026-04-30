/**
 * Vendored from: specification/ai-foundry/data-plane/Foundry/src/openai-responses/models.tsp
 * Foundry version pin: v1 (as of 2025-07-25)
 *
 * Full copy with imports fixed to relative vendored paths.
 * Includes @@copyProperties on OpenAI types, AgentReference, item type extensions.
 */
import "@azure-tools/typespec-azure-core/experimental";
import "@typespec/http";
import "@typespec/versioning";
import "../tools/models.tsp";
import "../_service.tsp";

using Azure.Core.Experimental;
using TypeSpec.Http;
using TypeSpec.Versioning;

#suppress "@azure-tools/typespec-azure-core/experimental-feature" "Experimental features applied to augment inherited OpenAI models"
namespace Azure.AI.Projects {
  @@changePropertyType(OpenAI.CreateResponse.`model`, string);
  @@changePropertyType(OpenAI.Response.`model`, string);

  // Temporary correction pending upstream fix
  @@changePropertyType(OpenAI.MCPToolCall.error, Record<unknown>);

  @@doc(OpenAI.CreateResponse.`model`,
    "The model deployment to use for the creation of this response."
  );
  @@doc(OpenAI.Response.`model`,
    "The model deployment to use for the creation of this response."
  );

  @@copyProperties(OpenAI.CreateResponse,
    {
      /**
       * (Deprecated) Use agent_reference instead.
       *  The agent to use for generating the response.
       */
      @removed(Versions.v1)
      agent?: AgentReference,

      /**
       * Optional session identifier for sandbox affinity. Currently only relevant for hosted agents.
       */
      @removed(Versions.v1)
      agent_session_id?: string,

      ...AzureCreateResponseOptions,
    }
  );

  /** Azure specific fields used in the creation of "Response" object */
  model AzureCreateResponseOptions {
    /** The agent to use for generating the response. */
    agent_reference?: AgentReference;

    /** The structured inputs to the response that can participate in prompt template substitution or tool argument bindings. */
    structured_inputs?: Record<unknown>;
  }

  @@copyProperties(OpenAI.Response,
    {
      /**
       * (Deprecated) Use agent_reference instead.
       * The agent used for this response
       */
      @removed(Versions.v1)
      agent?: AgentId,

      /**
       * The session identifier for this response.
       */
      @removed(Versions.v1)
      agent_session_id?: string,

      ...AzureCreateResponseDetails,
    }
  );

  /** Azure specific fields returned in a "Response" object */
  model AzureCreateResponseDetails {
    /** The agent used for this response */
    agent_reference: AgentReference | null;
  }

  @@withoutOmittedProperties(OpenAI.CodeInterpreterTool, "container");
  @@copyProperties(OpenAI.CodeInterpreterTool,
    {
      /** The code interpreter container. */
      #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" "Copying existing union type."
      container?: string | OpenAI.AutoCodeInterpreterToolParam,
    }
  );

  @@summary(OpenAI.AutoCodeInterpreterToolParam,
    "Automatic Code Interpreter Tool Parameters"
  );

  alias AgentNameQueryParam = {
    @query
    @doc("Filter by agent name.")
    agent_name?: string;
  };

  alias AgentIdQueryParam = {
    @query
    @doc("Filter by agent ID in the format `name:version`.")
    agent_id?: string;
  };

  alias ConversationIdQueryParam = {
    @query
    @doc("Filter by conversation ID.")
    conversation_id?: string;
  };

  model AgentReference {
    type: "agent_reference";

    @doc("The name of the agent.")
    @maxLength(256)
    name: string;

    @doc("The version identifier of the agent.")
    version?: string;
  }

  @removed(Versions.v1)
  model AgentId {
    type: "agent_id";

    @doc("The name of the agent.")
    @maxLength(256)
    name: string;

    @doc("The version identifier of the agent.")
    version: string;
  }

  // Extended item types
  union _AgentItemType {
    structured_outputs: "structured_outputs",
    oauth_consent_request: "oauth_consent_request",
    memory_search_call: "memory_search_call",
    workflow_action: "workflow_action",
    a2a_preview_call: "a2a_preview_call",
    a2a_preview_call_output: "a2a_preview_call_output",
    bing_grounding_call: "bing_grounding_call",
    bing_grounding_call_output: "bing_grounding_call_output",
    sharepoint_grounding_preview_call: "sharepoint_grounding_preview_call",
    sharepoint_grounding_preview_call_output: "sharepoint_grounding_preview_call_output",
    azure_ai_search_call: "azure_ai_search_call",
    azure_ai_search_call_output: "azure_ai_search_call_output",
    bing_custom_search_preview_call: "bing_custom_search_preview_call",
    bing_custom_search_preview_call_output: "bing_custom_search_preview_call_output",
    openapi_call: "openapi_call",
    openapi_call_output: "openapi_call_output",
    browser_automation_preview_call: "browser_automation_preview_call",
    browser_automation_preview_call_output: "browser_automation_preview_call_output",
    fabric_dataagent_preview_call: "fabric_dataagent_preview_call",
    fabric_dataagent_preview_call_output: "fabric_dataagent_preview_call_output",
    azure_function_call: "azure_function_call",
    azure_function_call_output: "azure_function_call_output",
  }

  @@copyVariants(OpenAI.ItemType, _AgentItemType);
  @@copyVariants(OpenAI.OutputItemType, _AgentItemType);

  @@copyProperties(OpenAI.OutputItem,
    {
      /** The information about the creator of the item */
      #suppress "@azure-tools/typespec-autorest/union-unsupported" "Temporary suppression."
      #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" "Required due to conflict."
      @removed(Versions.v1)
      created_by?: CreatedBy | string,

      @doc("The agent that created the item.")
      agent_reference?: AgentReference,

      @doc("The response on which the item is created.")
      response_id?: string,
    }
  );

  @removed(Versions.v1)
  model CreatedBy {
    @doc("The agent that created the item.")
    agent?: AgentId;

    @doc("The response on which the item is created.")
    response_id?: string;
  }

  model StructuredOutputsOutputItem extends OpenAI.OutputItem {
    type: "structured_outputs";
    @doc("The structured output captured during the response.")
    output: unknown;
  }

  model WorkflowActionOutputItem extends OpenAI.OutputItem {
    type: "workflow_action";
    kind: string;
    action_id: string;
    parent_action_id?: string;
    previous_action_id?: string;
    #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" ""
    status: "completed" | "failed" | "in_progress" | "cancelled";
  }

  union ResponseObjectType {
    response: "response",
  }

  model DeleteResponseResult {
    id: string;
    object: ResponseObjectType.response;
    deleted: true;
  }

  model OAuthConsentRequestOutputItem extends OpenAI.OutputItem {
    id: string;
    type: "oauth_consent_request";
    consent_link: string;
    server_label: string;
  }

  // ItemType query parameter (from openai-conversations/models.tsp)
  alias ItemTypeQueryParameter = {
    @query
    @doc("Filter by item type.")
    item_type?: OpenAI.ItemType;
  };
}
