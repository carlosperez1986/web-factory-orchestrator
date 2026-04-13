# Agentic Executive Diagrams

## Purpose

This pack contains executive-level diagrams to explain the agentic operating model
without technical noise. Use them in board updates, steering committees, and
transformation reviews.

## 1) Operating Model Stack (Who Decides What)

```mermaid
flowchart TB
    A["Control Plane\nOrchestrator\nDecision flow and sequencing"]
    B["Strategy Plane\nContracts and scope\nKPI alignment"]
    C["Build Plane\nSkills and blueprints\nExecution batches"]
    D["Assurance Plane\nQuality risk compliance\nGO or BLOCKED"]
    E["Learning Plane\nRetrospective and reuse\nContinuous improvement"]

    A --> B --> C --> D --> E

    style A fill:#d9edf7,stroke:#31708f
    style B fill:#fcf8e3,stroke:#8a6d3b
    style C fill:#e8f5e9,stroke:#2e7d32
    style D fill:#fdecea,stroke:#c62828
    style E fill:#f3e5f5,stroke:#6a1b9a
```

## 2) End-to-End Value Flow (From Intent to Verified Outcome)

```mermaid
flowchart LR
    I["Business intent\nObjective and constraints"] --> C["Strategy contract\nMachine-readable"]
    C --> R["Roadmap and batches\nDependencies and owners"]
    R --> X["Execution via skills\nBlueprint-first"]
    X --> EV["Evidence artifacts\nFiles and command outputs"]
    EV --> G["Gate decision\nGO or BLOCKED"]
    G --> V["Business value\nMeasured KPI impact"]

    style G fill:#fff3cd,stroke:#856404
    style EV fill:#e3f2fd,stroke:#1565c0
    style V fill:#d4edda,stroke:#155724
```

## 3) Capability Triage (Do We Need New Skills or Agents?)

```mermaid
flowchart TD
    Q["New business request"] --> M{"Covered by existing\nskills and blueprints?"}
    M -->|Yes| S["Use existing skill chain"]
    M -->|No| W{"Gap is workflow logic only?"}
    W -->|Yes| NS["Create or extend skill"]
    W -->|No| A{"Need role or tool\nisolation?"}
    A -->|Yes| NA["Create new agent\n+ skill if needed"]
    A -->|No| H["Escalate to human\nfor governance decision"]

    style S fill:#d4edda,stroke:#155724
    style NS fill:#e8f5e9,stroke:#2e7d32
    style NA fill:#e3f2fd,stroke:#1565c0
    style H fill:#fdecea,stroke:#c62828
```

## 4) Governance Loop (How Scale Stays Under Control)

```mermaid
flowchart LR
    P["Pilot initiative"] --> E["Execution and evidence"]
    E --> A["Assurance gates"]
    A --> K["KPI review"]
    K --> R["Retrospective"]
    R --> U["Update skills and blueprints"]
    U --> N["Next initiative at lower risk"]

    style K fill:#fff3cd,stroke:#856404
    style U fill:#e3f2fd,stroke:#1565c0
    style N fill:#d4edda,stroke:#155724
```

## Executive Talking Points

1. We are not automating tasks, we are standardizing decisions.
2. Evidence and gates are the control system, not optional documentation.
3. New capability requests are triaged before execution to avoid unmanaged risk.
4. Scale comes from blueprint and skill reuse, not from larger prompts.
