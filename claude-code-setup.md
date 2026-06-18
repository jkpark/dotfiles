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

### settings.json statusLine

`~/.claude/settings.json`의 `statusLine`을 플러그인 진입점으로 지정.
mise 환경에서 `node`가 statusline 실행 컨텍스트에서 확실히 잡히도록 **mise shim 절대경로**를 씀:

```json
"statusLine": {
  "type": "command",
  "command": "~/.local/share/mise/shims/node /Users/jkpark/.claude/plugins/cache/claude-dashboard/claude-dashboard/<버전>/dist/index.js"
}
```

- `<버전>` 부분은 설치 시점의 플러그인 버전(예: `1.29.0`). 실제 경로는 아래로 확인:
  ```bash
  ls -d ~/.claude/plugins/cache/claude-dashboard/claude-dashboard/*/dist/index.js
  ```
- `/claude-dashboard:setup`이 이 statusLine 경로를 자동으로 써주긴 하지만, 기본값은 그냥 `node ...`라서 mise 환경에서 안 잡힐 수 있음 → 그땐 위처럼 shim 절대경로로 수동 수정.

### 동작 테스트

```bash
echo '{"model":{"display_name":"Opus","id":"claude-opus-4-8"},"workspace":{"current_dir":"/Users/jkpark/dotfiles"},"cwd":"/Users/jkpark/dotfiles","cost":{"total_cost_usd":0.25}}' \
  | ~/.local/share/mise/shims/node ~/.claude/plugins/cache/claude-dashboard/claude-dashboard/<버전>/dist/index.js
```

색깔 입혀진 대시보드 한두 줄이 나오면 정상.

### 업데이트 시 주의

```
/plugin update claude-dashboard
/claude-dashboard:update   # statusLine 경로를 최신 버전 폴더로 갱신
```

업데이트하면 버전 폴더가 바뀌므로 settings.json의 경로도 갱신 필요.
`/claude-dashboard:update`가 해주지만, 이 명령은 `node`를 PATH에서 찾으므로
갱신 후 경로에 mise shim이 빠졌으면 다시 shim 절대경로로 고칠 것.

### 레이아웃/위젯 변경

`/claude-dashboard:setup`을 다시 실행하거나 `~/.claude/claude-dashboard.local.json`을 직접 편집.
모드: `compact`(1줄) / `normal`(2줄) / `detailed`(6줄) / `custom`.
