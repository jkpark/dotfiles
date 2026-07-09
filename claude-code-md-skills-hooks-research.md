# Claude Code 파워 유저는 CLAUDE.md / Skills / Hooks를 어떻게 다르게 쓰는가

> Deep research 종합 리포트 (2026-07-07)
> 5개 검색 각도 → 18개 소스 → 89개 주장 추출 → 25개 검증 → 22개 확인 / 3개 기각

## 한 줄 요약

세 메커니즘은 **로딩 시점**과 **강제력**이 근본적으로 다릅니다. 잘 쓰는 사람은 이 차이에 따라 역할을 엄격히 분리합니다:

| | CLAUDE.md | Skills | Hooks |
|---|---|---|---|
| **본질** | 항상 아는 **사실/규약** | 필요할 때 꺼내는 **절차** | 반드시 실행되는 **가드레일** |
| **로딩** | 매 세션 시작 시 자동 (영구 컨텍스트) | 이름·description만 상주, 본문은 호출 시 로드 | 라이프사이클 이벤트에서 셸 명령 실행 |
| **강제력** | 확률적 (advisory, 모델이 따를 수도 안 따를 수도) | 확률적 (모델이 호출 여부 결정) | **결정론적 (트리거 발동 보장)** |
| **비유** | 규칙집(Rulebook) | 도구(Tools)·플레이북 | 자동화(Automation)·harness가 강제하는 규칙 |

---

## 1. 각 메커니즘의 본질과 최적 용도

### CLAUDE.md — "항상 필요한 사실"
- 매 세션 시작 시 컨텍스트에 자동 로드됩니다. 따라서 **광범위하게, 항상 적용되는 것만** 담아야 합니다: 빌드 명령, 디렉터리 레이아웃, 모노레포 구조, 코딩 컨벤션, 팀 규범, 선호 라이브러리, 리뷰 체크리스트.
- **절차(procedure)는 여기 속하지 않습니다.** CLAUDE.md는 Claude가 매 순간 붙잡고 있어야 할 '사실'을 위한 것입니다.
- **결정적 한계: CLAUDE.md는 아무것도 강제하지 못합니다.** 내용은 컨텍스트로 전달될 뿐이고 준수는 확률적입니다. 지시가 많아질수록 준수율이 떨어진다는 연구(Jaroslawicz et al. 2025)도 있습니다.
  > 공식 문서 인용: *"CLAUDE.md is loaded every session, so only include things that apply broadly."*

### Skills — "가끔 필요한 절차"
- `.claude/skills/*/SKILL.md` 파일로, 배포 워크플로우·릴리스 체크리스트·코드 리뷰 같은 **절차적·온디맨드 워크플로우**를 패키징합니다. `/review-pr`, `/deploy-staging`처럼 슬래시 커맨드로 호출됩니다.
- **컨텍스트 비용이 저렴합니다.** 세션 시작 시엔 이름과 description만 로드되고(스킬당 대략 수십 토큰), 전체 본문은 Claude가 실제로 호출할 때만 로드됩니다 → **progressive disclosure**.
  > *"a skill's body loads only when it's used, so long reference material costs almost nothing until you need it."*

### Hooks — "반드시 일어나야 하는 것"
- 라이프사이클의 특정 지점에서 실행되는 사용자 정의 셸 명령입니다. **LLM이 실행을 선택하는지에 의존하지 않고, 특정 동작이 항상 일어나도록 보장하는 결정론적 제어**를 제공합니다.
- 용도: 프로젝트 규칙 강제, 반복 작업 자동화(편집 후 자동 포맷/lint), 기존 도구 통합(완료 시 Slack 알림), 위험 명령 차단.
  > 공식 문서: *"Unlike CLAUDE.md instructions which are advisory, hooks are deterministic and guarantee the action happens."*
- 한 실사용자 보고: CLAUDE.md에 "never run `rm -rf`"라고 쓰면 준수율이 ~70%인 반면, Hook은 100% 차단. `PreToolUse` hook은 툴 호출을 검사해 exit code 2로 거부하며, `--dangerously-skip-permissions` 하에서도 차단됩니다.

---

## 2. 어떤 걸 쓸지 결정하는 핵심 원칙

파워 유저들이 공유하는 판단 공식은 명확합니다:

> **요청(request, 확률적) → CLAUDE.md · Skills / 보장(guarantee, 결정론적) → Hook**

- 규칙이 **"~하면 좋겠다"** 수준이면 CLAUDE.md (항상 필요) 또는 Skill (가끔 필요).
- 규칙이 **"must / never / always"** — 반드시 지켜져야 하는 것이면 **Hook**. Hooks는 트리거 발동이 보장되는 **유일한** 확장 레이어입니다.
- 매 세션 주입돼야 하는 컨텍스트라면? **공식 권고는 SessionStart hook이 아니라 CLAUDE.md를 쓰라**는 것입니다.
  > *"For injecting context on every session start, consider using CLAUDE.md instead."*

간단한 결정 흐름:
1. 매번, 항상 필요한 사실인가? → **CLAUDE.md**
2. 가끔, 특정 작업에서만 필요한 절차인가? → **Skill**
3. 모델 판단과 무관하게 무조건 일어나야 하는가? → **Hook** (또는 permission)

---

## 3. 잘 쓰는 사람들의 공통 패턴

- **CLAUDE.md는 200줄 이하로, 소유자를 두고, 코드처럼 변경을 리뷰한다.** 짧고 밀도 높게 유지합니다.
- **Skills에 progressive disclosure 적용.** 상세 내용을 별도 파일(`references/api.md`, `assets/`, `examples/`)로 분리하고, 필요할 때만 온디맨드로 가져오게 합니다. 모든 걸 SKILL.md 한 파일에 몰아넣지 않습니다. (Anthropic의 PDF 스킬 예시: `reference.md`/`forms.md`/`scripts/`를 분리 번들하고 폼 작업 시에만 `forms.md`를 읽음.)
- **부작용 있는 워크플로우엔 `disable-model-invocation: true`.** 모델이 임의로 자동 호출하지 못하게 막고, 사람이 `/skill-name`으로만 트리거하게 합니다. (예: `/fix-issue 1234`)
- **CLAUDE.md에서 이미 잘 지켜지는 지시는 삭제하거나 Hook으로 전환한다.** "지시 없이도 Claude가 이미 올바르게 하는 것"은 노이즈일 뿐입니다.
- **세 메커니즘을 대립이 아니라 조합으로 쓴다.** "Hook 대신 CLAUDE.md"가 아니라, 사실은 CLAUDE.md·절차는 Skill·강제는 Hook으로 함께 씁니다.

---

## 4. 흔히 하는 실수 (안티패턴)

**① 비대해진 CLAUDE.md** ⭐ 가장 흔함
- 너무 길면 중요한 규칙이 노이즈에 묻혀 **Claude가 절반을 무시합니다.**
  > *"If your CLAUDE.md is too long, Claude ignores half of it because important rules get lost in the noise."*
- 해결: 무자비하게 가지치기. 이미 잘 지켜지는 건 삭제하거나 Hook으로.

**② 항상 필요한 규약을 Skill에 넣기**
- 스킬 활성화는 **확률적(model-invoked)**입니다. 매 세션 반드시 지켜져야 할 규칙을 Skill에 넣으면, **스킬이 트리거되지 않을 때 조용히(silently) 누락**됩니다. (실전 보고: 일부 eval에서 56% 미호출, 한 감사에선 214개 중 73%가 조용히 깨짐.)
- 해결: 항상 필요한 규칙은 CLAUDE.md에, 보장이 필요하면 Hook에.

**③ "절대 일어나면 안 되는 일"을 프롬프트 지시로 처리**
- 긴 세션·모호한 상황·압박·프롬프트 인젝션에서 프롬프트 기반 "always/never" 규칙은 실패합니다.
  > *"A real guardrail needs to be deterministic, and the enforcement methods are hooks and permissions."*
- 해결: 진짜 가드레일은 Hook 또는 permission으로.

**④ Hook에 복잡한 분기/판단 로직 넣기** (신뢰도 medium)
- Hook이 복잡한 분기를 하고 있다면, 그건 **Claude가 명시적으로 제어하는 Skill로 옮겨야 한다는 신호**입니다. Hook 로직은 디버깅 가능하도록 단순·결정론적으로 유지합니다(Hook은 샌드박스 없이 전체 권한으로 실행되고 exit-code 함정이 있음).

---

## 검증에서 기각된 통념 (참고)

리서치 중 3개 주장은 3-0으로 기각됐습니다 — 널리 퍼졌지만 부정확한 통념입니다:
- ❌ "Hook은 Claude가 존재를 모른다" / 이벤트 목록·`settings.json` 세부가 항상 그렇다 — 부정확
- ❌ "Skills는 라이브 데이터 접근·비즈니스 도구 연결용이다" — Skills의 본질과 어긋남
- ❌ "Skill description은 'do X' 요약이 아니라 'use when you need X' 트리거로 써야 한다" — 검증 통과 못 함

## 주의할 뉘앙스 (caveats)

- **"Hook은 항상 결정론적"은 command hook에 한정**됩니다. 신형 prompt/agent hook 타입은 LLM 판단을 사용합니다(단, 트리거 발동 자체는 여전히 보장됨).
- **Stop hook**은 8회 연속 차단 후 Claude가 override할 수 있습니다 — "보장"은 무한 차단이 아니라 매 트리거마다 발동을 의미합니다.
- **Skill도 완전 무비용은 아닙니다.** 메타데이터는 항상 상주하고, 한 번 호출된 본문은 세션 내내 컨텍스트에 잔류합니다.
- 이 구조(통합된 `.claude/skills/`, `disable-model-invocation`, prompt/agent hook)는 2026년 기준 비교적 최신 기능이라 변경될 수 있습니다.

---

## 남은 질문 (open questions)

- Skills 활성화 신뢰도를 실전에서 얼마나 높일 수 있는가 — directive한 description 작성이나 명시적 슬래시 호출로 어느 정도 개선되며, 자동 호출 실패율은 어떤 조건에서 발생하는가?
- 신형 prompt/agent hook 타입(LLM 판단을 사용하는 hook)은 기존 command hook의 '결정론성' 프레이밍을 어떻게 바꾸는가?
- subagents와 plugins는 CLAUDE.md/Skills/Hooks와 어떻게 조합·역할 분담되는가?
- 대규모 모노레포/팀 환경에서 계층적 CLAUDE.md(글로벌/프로젝트/서브디렉터리) 로딩과 200줄 제한을 실제로 어떻게 운영하는가?

---

## 주요 출처

**공식(primary):**
- [Claude Code Overview](https://code.claude.com/docs/en/overview)
- [Best Practices](https://code.claude.com/docs/en/best-practices)
- [Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Skills](https://code.claude.com/docs/en/skills)
- [Steering Claude Code (Anthropic 블로그)](https://claude.com/blog/steering-claude-code-skills-hooks-rules-subagents-and-more)

**실무 블로그:**
- [확장 레이어 결정 가이드](https://hidekazu-konishi.com/entry/claude_code_extension_layers_decision_guide.html)
- [Writing a good CLAUDE.md (HumanLayer)](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Skills vs Hooks (MindStudio)](https://www.mindstudio.ai/blog/claude-code-skills-vs-hooks-difference)
- [When to Use Which (Build This Now)](https://www.buildthisnow.com/blog/tools/claude-code-skills-vs-subagents-vs-hooks)
- [Claude Code Hooks (Blake Crosley)](https://blakecrosley.com/blog/claude-code-hooks)

---

**핵심 한 문장:** 사실은 CLAUDE.md, 절차는 Skill, 보장은 Hook — 그리고 대부분의 실수는 "확률적으로 충분한 것"과 "결정론적으로 보장돼야 하는 것"을 혼동하는 데서 나옵니다.
