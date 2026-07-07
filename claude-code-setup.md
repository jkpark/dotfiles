# Claude Code 설정 메모

OS 포맷 후 Claude Code를 다시 세팅할 때 참고하는 문서. (수동 설정용)

## Statusline (상태줄) 플러그인

[`uppinote20/claude-dashboard`](https://github.com/uppinote20/claude-dashboard) 플러그인으로 꾸밈.

- **요구사항**: Claude Code v1.0.80+, Node.js 18+
- 현재 머신은 Node를 **mise**로 글로벌 설치해서 씀 (`mise use -g node@latest`)

### 설치 순서

Claude Code 프롬프트에서 슬래시 명령으로:

```
/plugin marketplace add uppinote20/claude-dashboard
/plugin install claude-dashboard
/reload-plugins
```

### 적용한 설정

`/claude-dashboard:setup normal en pro`
→ **normal 모드(2줄), 영어, Pro 플랜**

설정 파일 `~/.claude/claude-dashboard.local.json`:

```json
{
  "language": "en",
  "plan": "pro",
  "displayMode": "normal",
  "theme": "default",
  "cache": {
    "ttlSeconds": 300
  }
}
```

### Statusline

[`sirmalloc/ccstatusline`](https://github.com/sirmalloc/ccstatusline) 사용 중.

## cmux-skills 스킬 패키지

[`manaflow-ai/cmux-skills`](https://github.com/manaflow-ai/cmux-skills)는 Claude Code에서 터미널 기반 UI(cmux)를 다루기 위한 스킬 패키지.

### 포함된 스킬

- **cmux-cli** - cmux CLI 참조 (소켓, 워크스페이스, 패널)
- **cmux-config** - `~/.config/cmux/cmux.json` 설정 관리
- **cmux-workspace** - 현재 워크스페이스 내 작업
- **cmux-browser** - 브라우저 표면 제어
- **cmux-artifact** - HTML 워크스루 아티팩트 생성
- **cmux-sidebar-builder** - 좌측 사이드바 커스텀 뷰

### 설치

```bash
npx skills add manaflow-ai/cmux-skills -g --all
```

또는 특정 스킬만 설치:
```bash
npx skills add manaflow-ai/cmux-skills --skill cmux-cli cmux-browser --agent claude-code
```

설치 후 Claude Code에서 관련 스킬을 `/cmux-browser` 등으로 사용 가능.
