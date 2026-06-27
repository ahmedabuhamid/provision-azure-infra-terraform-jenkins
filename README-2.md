@startuml AgentAssist_Platform_Architecture
!theme cerulean-outline
skinparam backgroundColor #FAFAFA
skinparam roundCorner 15
skinparam defaultFontName "Segoe UI"
skinparam shadowing false
skinparam ArrowColor #555555
skinparam packageBorderColor #3B82F6
skinparam noteBorderColor #D1D5DB

title AgentAssist Platform — OpenShift Deployment Architecture

cloud "External Clients" as ext #E0F2FE {
  actor "Agent Desktop" as agent
  actor "Admin / API Consumer" as admin
}

package "OpenShift Cluster" as ocp #F8FAFC {

  package "Namespace: agentassist" as ns #FFFFFF {

    rectangle "**OpenShift Routes** (TLS Edge)" as routes #EFF6FF {
      portin " " as r1
      portin " " as r2
      portin " " as r3
      portin " " as r4
    }

    together {
      rectangle "**GSA2**\n//Gateway & Orchestrator//\n\nPort: 55200\nImage: gsa2:1.5.0\nCPU: 24-48 | RAM: 48-96 Gi" as gsa2 #CCFBF1 {
      }

      rectangle "**AI Assistant**\n//Intelligence API//\n\nPort: 8000\nImage: ai-assistant:1.1.2\nCPU: 8-16 | RAM: 8-16 Gi" as aiassist #DBEAFE {
      }
    }

    together {
      rectangle "**ASR**  🖥️ GPU\n//Speech Recognition + NLU//\n\nPorts: 55220 (AR), 55230 (EN), 55210 (NLU)\nImage: asr:1.0.0\nCPU: 16 | RAM: 16-32 Gi\nGPU: 1× NVIDIA" as asr #D1FAE5 {
      }

      rectangle "**vLLM**  🖥️ GPU\n//Multi-Model LLM Server//\n\nPorts: 4545 (14B), 4544 (7B), 4546 (Embed)\nImage: llm-server:0.19.1\nCPU: 16 | RAM: 64-112 Gi\nGPU: 1× NVIDIA" as vllm #EDE9FE {
      }
    }

    database "**CephFS PVCs**" as storage #FEF3C7 {
      card "models-pvc\n200 Gi" as pvmod
      card "logs-pvc\n20 Gi" as pvlog
    }

    rectangle "**Monitoring**" as mon #FEE2E2 {
      component "ServiceMonitors\n(30s interval)" as sm
      component "PrometheusRules\n(Alerts)" as pr
      component "Dashboard ConfigMap" as dash
    }
database "**Redis**" as redis #FDE68A
  }

  
  database "**MSSQL**\nSpeechlogCentralV8" as mssql #C7D2FE
}

' ── External access ──
agent --> routes
admin --> routes

' ── Route to Services ──
routes --> gsa2 : HTTPS → :55200
routes --> aiassist : HTTPS → :8000
routes --> asr : HTTPS → :55220
routes --> vllm : HTTPS → :4545

' ── Service-to-service ──
gsa2 --> asr : "ASR Arabic :55220\nASR English :55230\nNLU :55210"
gsa2 --> aiassist : "AI Assist API\n:8000/v1"
aiassist --> vllm : "LLM 14B :4545\nLLM 7B :4544\nEmbedding :4546"

' ── External dependencies ──
gsa2 --> redis : "Cache\n(DB 3, :6379)"
aiassist --> redis : "Config cache\n(DB 5, :6379)"
aiassist --> mssql : "Prompts/Triggers\n(:1442)"

' ── Storage ──
vllm --> pvmod
asr --> pvmod
gsa2 --> pvmod
gsa2 --> pvlog

aiassist --> pvlog


' ── Monitoring ──
gsa2 -[dashed]-> sm
aiassist -[dashed]-> sm
asr -[dashed]-> sm
vllm -[dashed]-> sm
sm --> pr
pr --> dash

legend right
  |= Colour |= Meaning |
  | <#CCFBF1> | GSA2 (Gateway) |
  | <#DBEAFE> | AI Assistant |
  | <#D1FAE5> | ASR (GPU) |
  | <#EDE9FE> | vLLM (GPU) |
  | <#FEF3C7> | Persistent Storage |
  | <#FEE2E2> | Monitoring |
end legend

@enduml
