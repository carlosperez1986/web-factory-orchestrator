# WFO Visual Flowcharts

## Session Start Protocol

```mermaid
flowchart TD
    A["User invokes @Orchestrator"] --> B["Search current_state-*.json in workspace"]
    
    B --> C{Files found?}
    
    C -->|Yes| D["List all active projects<br/>+ current phase + step"]
    C -->|No| E["Go to Intake<br/>Awaiting briefing input"]
    
    D --> F["User selects project<br/>OR types 'new'"]
    
    F -->|Resume existing| G["Read current_state-{name}.json<br/>Read PROJECT_ROADMAP-{name}.md"]
    F -->|new| E
    
    G --> H{Check phase}
    
    H -->|"define"| I["Show roadmap<br/>Ask: 'Proceed to Phase 2?'"]
    H -->|"build"| J["Show active skill<br/>Resume execution"]
    H -->|"deploy"| K["Show deployment status<br/>Resume execution"]
    
    I -->|No| L["Proposal: modify roadmap"]
    I -->|Yes| M["Transition to Phase 2<br/>→ project-scaffolding skill"]
    
    E --> N["Intake: Receive briefing<br/>Start briefing-synthesis"]
    
    style A fill:#e1f5ff
    style M fill:#c8e6c9
    style E fill:#fff9c4
```

---

## Phase 2 Activation: Repository Detection (Manual Create Prerequisite)

```mermaid
flowchart TD
    A["Phase 1 Complete & Approved<br/>User: 'Proceed'"] --> B["Orchestrator: project-scaffolding skill"]
    
    B --> C["Step 1: Repo Detection<br/>Check if repo exists on GitHub"]
    
    C --> D{Repo exists?}
    
    D -->|Yes| E["Step 2: Clone repo<br/>use provided repo URL"]
    D -->|No| F["BLOCKER: Create repo manually<br/>in GitHub Web first"]
    
    F --> F1["Ask user to create repo manually<br/>and share URL"]
    F1 -->|User: No| F2["Abort Phase 2<br/>Roadmap stays in hub"]
    F1 -->|User: Yes| G["User provides existing repo URL"]
    
    E --> E1{"Existing app/CI-CD already working?"}
    E1 -->|Yes| E2["Adoption mode<br/>Assess Program.cs, .csproj,<br/>Decap config, workflows"]
    E1 -->|No| H
    E2 --> H
    G --> E
    
    H --> I["Step 5: Initialize or augment scaffold<br/>Copy blueprints only if missing"]
    
    I --> J["Step 6: Create Decap Admin Structure<br/>mkdir wwwroot/admin/"]
    
    J --> K["Step 7: Setup GitHub Workflows<br/>Copy .github/workflows/"]
    
    K --> L["Step 8: Commit & Push<br/>git add . && git commit<br/>'chore: init WFO project scaffold'"]
    
    L --> M["Update current_state-{name}.json<br/>phase = 'build'<br/>active_agent = '@Developer'"]
    
    M --> N["✅ Phase 2 Ready<br/>Repo is live & initialized"]
    
    style A fill:#c8e6c9
    style D fill:#fff9c4
    style F1 fill:#ffe0b2
    style E2 fill:#e1f5ff
    style N fill:#a5d6a7
```

---

## Existing Repo Adoption Example: PureWipe

```mermaid
flowchart TD
    A["User: Use existing repo purewipe"] --> B["Clone carlosperez1986/purewipe"]
    B --> C["Assess repo"]
    C --> D["Detect: Razor Pages monolith"]
    C --> E["Detect: net8.0 current target"]
    C --> F["Detect: Decap CMS already integrated"]
    C --> G["Detect: GitHub Actions deploy already working"]
    C --> H["Detect: shared subpath deployment with PATH_BASE=/purewipe"]

    D --> I["Write Existing Repo Assessment into roadmap"]
    E --> I
    F --> I
    G --> I
    H --> I

    I --> J["Preserve current workflows and deploy topology"]
    J --> K["Import current_state + roadmap into repo"]
    K --> L["Create modernization tasks:<br/>secrets rotation, legacy cleanup,<br/>optional .NET 9 migration"]
    L --> M["Resume Phase 2 under WFO governance"]

    style A fill:#fff9c4
    style G fill:#c8e6c9
    style M fill:#a5d6a7
```

---

## Multi-Skill Pipeline (Full Journey)

```mermaid
flowchart LR
    A["briefing-synthesis<br/>Extract intent<br/>→ roadmap skeleton"] --> B["project-estimation<br/>Forecast cost/time/tokens<br/>→ stack locked"]
    B --> C["USER GATE 1<br/>Approve roadmap?"]
    C -->|Changes| D["Modify roadmap"]
    D --> B
    C -->|Proceed| E["project-scaffolding<br/>Create or adopt repo<br/>→ repo ready"]
    E --> F["spec-driven-architecture<br/>Route matrix, contracts,<br/>component map, batches<br/>→ IMPLEMENTATION_SPEC"]
    F --> G["look-and-feel-ingestion<br/>Image/URL/Stitch input<br/>→ DESIGN_STYLE_CONTRACT"]
    G --> H["github-project-bootstrap<br/>GitHub Issues + labels<br/>+ Project board<br/>→ delivery tracking"]
    H --> I["content-service-and-data-wiring<br/>C# models + services<br/>+ PageModel bindings<br/>→ backend code"]
    I --> J["integrate-ui-component<br/>Razor Pages + Bootstrap 5<br/>+ responsive sections<br/>→ frontend code"]
    J --> K["seo-aio-optimization<br/>Schema.org + AIO meta<br/>+ sitemap.xml<br/>→ discoverability"]
    K --> L["USER GATE 2<br/>Code review OK?"]
    L -->|No| M["Request changes"]
    M --> I
    L -->|Yes| N["security-audit<br/>@Auditor — go/no-go<br/>CVE + config scan"]
    N --> O["vps-provisioning<br/>Nginx + systemd<br/>+ CI/CD deploy"]
    O --> P["✅ DEPLOYED"]

    style C fill:#fff9c4
    style L fill:#fff9c4
    style G fill:#d1ecf1
    style H fill:#e1f5ff
    style I fill:#f3e5f5
    style J fill:#f3e5f5
    style N fill:#fce4ec
    style P fill:#a5d6a7
```

---

## Central Hub + Distributed Repos (Deployment Model)

```mermaid
graph TB
    subgraph Hub ["Central: web-factory-orchestrator"]
        HS1["current_state-pure-wipe.json<br/>phase: build"]
        HS2["PROJECT_ROADMAP-pure-wipe.md"]
        HS3["Skills Library"]
        HS4["Blueprints"]
    end
    
    subgraph PR1 ["Project Repo: pure-wipe"]
        PR1A["Program.cs<br/>/Pages/ + /Models/"]
        PR1B["current_state-pure-wipe.json<br/>(copy from hub)"]
        PR1C["PROJECT_ROADMAP-pure-wipe.md<br/>(copy from hub)"]
        PR1D[".github/workflows/<br/>CI/CD pipelines"]
    end
    
    subgraph VPS1 ["VPS: pure-wipe.domain"]
        VPS1A["Nginx (reverse proxy)"]
        VPS1B["Systemd service<br/>(running .NET app)"]
        VPS1C["Decap CMS (via Git)"]
    end
    
    subgraph PR2 ["Project Repo: acme-corp"]
        PR2A["Program.cs<br/>/Pages/ + /Models/"]
        PR2B["current_state-acme-corp.json"]
        PR2C["PROJECT_ROADMAP-acme-corp.md"]
        PR2D[".github/workflows/"]
    end
    
    subgraph VPS2 ["VPS: acme.domain"]
        VPS2A["Nginx"]
        VPS2B["Systemd service"]
        VPS2C["Decap CMS"]
    end
    
    Hub -->|"project-scaffolding<br/>Step 4: Copy state/roadmap"| PR1
    Hub -->|"project-scaffolding<br/>Step 5: Copy blueprint"| PR1
    Hub -->|"Skills ref for future phases"| PR1
    
    PR1 -->|"GitHub Actions<br/>Build trigger"| VPS1
    PR1 -->|"Deploy script<br/>(from blueprints)"| VPS1
    
    Hub -->|"project-scaffolding"| PR2
    Hub -->|"Skills ref"| PR2
    PR2 -->|"GitHub Actions"| VPS2
    
    style Hub fill:#e3f2fd
    style PR1 fill:#f3e5f5
    style VPS1 fill:#c8e6c9
    style PR2 fill:#f3e5f5
    style VPS2 fill:#c8e6c9
```

---

## current_state Lifecycle

```mermaid
stateDiagram-v2
    [*] --> CREATED: briefing-synthesis<br/>Step 5
    
    CREATED: phase: "define"<br/>active_skill: briefing-synthesis<br/>tokens: X
    
    CREATED --> CREATED: project-estimation updates<br/>tokens decrease
    
    CREATED --> APPROVED: USER GATE 1<br/>"Proceed"
    
    APPROVED: phase: "define"<br/>awaiting Phase 2
    
    APPROVED --> BUILD: project-scaffolding<br/>uses existing repo URL
    
    BUILD: phase: "build"<br/>active_agent: @Developer<br/>location: client repo
    
    BUILD --> BUILD: spec-driven-architecture<br/>look-and-feel-ingestion<br/>content-service-and-data-wiring<br/>integrate-ui-component<br/>seo-aio-optimization<br/>tokens decrease
    
    BUILD --> REVIEW: USER GATE 2<br/>"Code review OK"
    
    REVIEW: phase: "build"<br/>awaiting security
    
    REVIEW --> DEPLOY: security-audit passes
    
    DEPLOY: phase: "deploy"<br/>active_agent: @DevOps
    
    DEPLOY --> DEPLOYED: vps-provisioning<br/>completes
    
    DEPLOYED: phase: "deployed"<br/>completed_at: YYYY-MM-DD
    
    DEPLOYED --> [*]
```

---

## Build Phase: Skill Ownership and Output Type

```mermaid
flowchart TD
    subgraph define ["Phase 1 — Define (Hub context)"]
        S1["briefing-synthesis<br/>OUTPUT: roadmap skeleton<br/>sitemap · motives · feature components"]
        S2["project-estimation-and-stack-selection<br/>OUTPUT: token forecast · cost · margin<br/>stack decision · Decap CMS baseline"]
        S1 --> S2
    end

    GU1["⏸ USER GATE 1<br/>Human approves roadmap"]

    subgraph build_infra ["Phase 2A — Planning (Client repo context)"]
        S3["project-scaffolding<br/>OUTPUT: repository ready<br/>blueprint seeded · workflows in place"]
        S4["spec-driven-architecture<br/>OUTPUT: IMPLEMENTATION_SPEC<br/>route matrix · contracts · batches"]
        S5["look-and-feel-ingestion<br/>OUTPUT: DESIGN_STYLE_CONTRACT<br/>image/URL/Stitch visual intake"]
        S6["github-project-bootstrap<br/>OUTPUT: GitHub Issues + Project board<br/>⚠️ NO CODE — delivery tracking only"]
        S3 --> S4 --> S5 --> S6
    end

    subgraph build_code ["Phase 2B — Code (Client repo context)"]
        S7["content-service-and-data-wiring<br/>OUTPUT: C# code<br/>models · services · PageModel bindings"]
        S8["integrate-ui-component<br/>OUTPUT: Razor + Bootstrap code<br/>page sections · shared layout · responsive UI"]
        S9["seo-aio-optimization<br/>OUTPUT: meta / schema markup<br/>Schema.org · AIO meta · sitemap.xml"]
        S7 --> S8 --> S9
    end

    GU2["⏸ USER GATE 2<br/>Human code review"]

    subgraph deploy ["Phase 3 — Deploy"]
        S10["security-audit<br/>AGENT: @Auditor (restricted tools)<br/>OUTPUT: go/no-go report"]
        S11["vps-provisioning ⌛<br/>OUTPUT: Nginx · systemd · CI/CD pipeline"]
        S10 --> S11
    end

    define --> GU1 --> build_infra --> build_code --> GU2 --> deploy

    style S5 fill:#d1ecf1
    style S6 fill:#e1f5ff
    style S7 fill:#f3e5f5
    style S8 fill:#f3e5f5
    style S10 fill:#fce4ec
    style S11 fill:#ffe0b2
    style GU1 fill:#fff9c4
    style GU2 fill:#fff9c4
```

---

## WFO Full Sequence: From Briefing to Deployed Site

```mermaid
sequenceDiagram
    actor Human as Human Operator
    participant Orch as @Orchestrator
    participant Hub as Hub Workspace<br/>(web-factory-orchestrator)
    participant Repo as Client Repo<br/>(github.com/user/project)
    participant GH as GitHub<br/>(Issues + Project)
    participant Aud as @Auditor
    participant VPS as VPS

    Human->>Orch: Provide briefing (PDF / inbox / chat text)

    rect rgb(225, 245, 255)
        Note over Orch,Hub: Phase 1 — Define (Hub context)
        Orch->>Hub: Run briefing-synthesis → write PROJECT_ROADMAP
        Orch->>Hub: Run project-estimation → write Estimation + Stack Decision
        Orch-->>Human: "Roadmap ready. Approve to proceed?"
    end

    Human->>Orch: Proceed ✅ (USER GATE 1)

    rect rgb(243, 229, 245)
        Note over Orch,Repo: Phase 2A — Planning (switches to repo context)
        Orch->>Repo: project-scaffolding → create or adopt repo + seed blueprint
        Orch->>Repo: spec-driven-architecture → write IMPLEMENTATION_SPEC
        Orch->>Repo: look-and-feel-ingestion → ingest image/URL/Stitch and write DESIGN_STYLE_CONTRACT
        Orch->>GH: github-project-bootstrap → create Issues + labels + Project board
        Note over GH: No code yet — only delivery tracking
    end

    rect rgb(232, 245, 233)
        Note over Orch,Repo: Phase 2B — Code
        Orch->>Repo: content-service-and-data-wiring → write C# models, services, PageModel bindings
        Orch->>Repo: integrate-ui-component → write Razor Pages + Bootstrap 5 UI
        Orch->>Repo: seo-aio-optimization → write Schema.org, AIO meta, sitemap.xml
        Orch-->>Human: "Code complete. Please review."
    end

    Human->>Orch: Approved ✅ (USER GATE 2)

    rect rgb(252, 228, 236)
        Note over Aud: Phase 3 — Deploy (@Auditor restricted tools: read/search/execute — no edit)
        Orch->>Aud: Delegate security-audit
        Aud->>Repo: Scan Nginx config, .NET config, form handlers, secrets posture
        Aud-->>Orch: GO ✅ (or BLOCKED with findings)
    end

    rect rgb(255, 224, 178)
        Note over Orch,VPS: Deploy
        Orch->>VPS: vps-provisioning → Nginx + systemd config
        Repo->>VPS: GitHub Actions CI/CD → build + deploy .NET app
        Orch-->>Human: "Deployed ✅ — site live at {url}"
    end
```
