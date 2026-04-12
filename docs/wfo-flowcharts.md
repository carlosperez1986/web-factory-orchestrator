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

## Phase 2 Activation: Repository Detection & Creation

```mermaid
flowchart TD
    A["Phase 1 Complete & Approved<br/>User: 'Proceed'"] --> B["Orchestrator: project-scaffolding skill"]
    
    B --> C["Step 1: Repo Detection<br/>Check if repo exists on GitHub"]
    
    C --> D{Repo exists?}
    
    D -->|Yes| E["Step 2: Clone repo<br/>gh repo clone user/project-name"]
    D -->|No| F["Step 3: Create repo<br/>Confirm with user first"]
    
    F --> F1["Ask: 'Create new repo?<br/>Location: github.com/user/{project-name}'"]
    F1 -->|User: No| F2["Abort Phase 2<br/>Roadmap stays in hub"]
    F1 -->|User: Yes| G["gh repo create {project-name} --private --clone"]
    
    E --> E1{"Existing app/CI-CD already working?"}
    E1 -->|Yes| E2["Adoption mode<br/>Assess Program.cs, .csproj,<br/>Decap config, workflows"]
    E1 -->|No| H
    E2 --> H
    G --> H
    
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
    A["briefing-synthesis<br/>Extract intent"] --> B["project-estimation<br/>Forecast cost/time"]
    B --> C["USER GATE 1<br/>Approve roadmap?"]
    C -->|Changes| D["Modify roadmap"]
    D --> B
    C -->|Proceed| E["project-scaffolding<br/>Create repo"]
    E --> F["spec-driven-architecture<br/>Generate specs"]
    F --> G["integrate-ui-component<br/>Build UI"]
    G --> H["decap-cms-config<br/>Admin setup"]
    H --> I["USER GATE 2<br/>Code review OK?"]
    I -->|No| J["Request changes"]
    J --> F
    I -->|Yes| K["security-audit<br/>CVE scan"]
    K --> L["vps-provisioning<br/>Deploy"]
    L --> M["✅ DEPLOYED"]
    
    C -->|phase: define| style C fill:#fff9c4
    E -->|phase: build| style E fill:#fff9c4
    K -->|phase: deploy| style K fill:#fff9c4
    M fill:#a5d6a7
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
    
    APPROVED --> BUILD: project-scaffolding<br/>creates repo
    
    BUILD: phase: "build"<br/>active_agent: @Developer<br/>location: client repo
    
    BUILD --> BUILD: spec-driven-architecture<br/>integrate-ui<br/>decap-cms-config<br/>tokens decrease
    
    BUILD --> REVIEW: USER GATE 2<br/>"Code review OK"
    
    REVIEW: phase: "build"<br/>awaiting security
    
    REVIEW --> DEPLOY: security-audit passes
    
    DEPLOY: phase: "deploy"<br/>active_agent: @DevOps
    
    DEPLOY --> DEPLOYED: vps-provisioning<br/>completes
    
    DEPLOYED: phase: "deployed"<br/>completed_at: YYYY-MM-DD
    
    DEPLOYED --> [*]
```
