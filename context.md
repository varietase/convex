---
team_size: 7
mode: team
build_type: hackathon
time_budget: 4d
judged: true
computes_numbers: true
exposed_surface: true
outlives_demo: true
selection_mode: auto
competition:
  name: OpenAI Build Week (Manila build sprint + Global submission)
  theme: "Build something real with Codex and GPT-5.6"
  format: "Live Manila demo, then public Devpost submission with a sub-3-minute YouTube demo"
  rubric:
    - Technological Implementation
    - Design
    - Potential Impact
    - Quality of the Idea
  hard_requirements:
    - Use Codex and GPT-5.6 meaningfully
    - Working public or judge-accessible project
    - Public YouTube demo under 3 minutes with voiceover
    - Repository and README documenting Codex collaboration
    - Main Codex /feedback Session ID
    - English submission materials
---

# Build context — X-Ray for AI Code

Manila starts with five builders for the 5.5-hour sprint; Geinel and Jim join the Global polish phase, bringing the team to seven. The implementation baseline is two repositories: a Vercel-hosted web client and a Hugging Face Docker Space running FastAPI, LangChain, and LangGraph. The deployed project must remain available through Global judging, so operational basics are in scope even though this is not yet a production service. The judged design surface should follow the premium dark-first visual direction in `docs/visual-direction.md` and the implementation tokens in `docs/design-system.md` without expanding feature scope.
