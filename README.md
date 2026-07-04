# nvchad-config

NvChad(v2.5) 기반 Neovim 설정. Python(Django/FastAPI) 개발 환경 중심.

- 디버깅: nvim-dap + dap-ui + nvim-dap-python (Django/FastAPI launch config 내장)
- 테스트: neotest + neotest-python (pytest)
- venv: venv-selector.nvim + statusline venv 표시
- git: lazygit / diffview / gitsigns inline blame
- 기타: bufferline, persistence(세션), treesitter 폴딩

## 새 머신 설치

### 1. 선행 도구 (brew)

```bash
brew install neovim git ripgrep fd lazygit node python
brew install --cask font-jetbrains-mono-nerd-font
```

- `ripgrep`, `fd`: telescope 검색용
- `lazygit`: `<leader>gg` git TUI
- `node`: pyright 등 일부 LSP 서버 구동에 필요
- Nerd Font: 터미널 폰트로 설정해야 아이콘 깨지지 않음

### 2. 설정 clone

```bash
# 기존 설정 있으면 백업
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null

git clone git@github.com:jongwoo315/nvchad-config.git ~/.config/nvim

# SSH 키 아직 없으면 (새 맥) https로:
# git clone https://github.com/jongwoo315/nvchad-config.git ~/.config/nvim
```

### 3. 첫 실행

```bash
nvim
```

- lazy.nvim이 자동 bootstrap → `lazy-lock.json`에 고정된 버전으로 플러그인 전체 설치
- 설치 끝나면 재시작 후:

```vim
:MasonInstallAll
```

→ pyright, ruff, html-lsp, css-lsp, lua-language-server, stylua, debugpy 설치
(`lua/plugins/init.lua`의 mason `ensure_installed` 목록 기준)

treesitter 파서(python, javascript 등)는 `ensure_installed`로 자동 설치 — `:TSInstall` 수동 실행 불필요

### 4. 확인

```vim
:checkhealth        " 전반 상태
:Mason              " LSP/DAP 설치 상태
:Lazy               " 플러그인 상태
```

## 프로젝트별 설정 (repo 밖 범위)

- **venv**: 프로젝트에서 `<leader>vs`로 선택 → pyright + dap 경로 자동 전환
- **테스트**: venv에 `pip install pytest pytest-django` (Django 프로젝트)
- **디버깅**: `<leader>db` breakpoint → `<leader>dc` → "Django runserver" 또는 "FastAPI (uvicorn)" 선택
  - Django config는 `--noreload` 강제 (reloader fork가 디버거 끊음)

## 키맵

`<leader>` = Space. 잊었을 때: Space 누르고 잠깐 대기 → which-key 팝업, 또는 `<leader>ch` (NvChad 치트시트).

### 기본 (커스텀)

| 키 | 동작 |
|---|---|
| `jk` (insert) | ESC |
| `;` | `:` (command mode) |
| `<Tab>` / `<S-Tab>` | 다음 / 이전 버퍼 |
| `<A-,>` / `<A-.>` | 버퍼 탭 순서 왼쪽 / 오른쪽으로 이동 |
| `<leader>x` | 버퍼 닫기 (창 레이아웃 유지) |
| `<C-h/j/k/l>` | 창 이동 (NvChad 기본) |
| `<C-화살표>` | 창 크기 조절 (±2) |
| `<C-w>=` / `<C-w>\|` / `<C-w>_` | 창 균등 / 너비 최대 / 높이 최대 (vim 내장) |
| `zl` / `zh`, `zL` / `zH` | 가로 스크롤 1칸 / 반화면 (nowrap 창에서, vim 내장) |
| `<C-d>` | 반 페이지 아래 (EOF 아래 빈 공간 스크롤 방지 커스텀) |

### 파일 탐색 (NvChad 기본)

| 키 | 동작 |
|---|---|
| `<C-n>` | nvim-tree 토글 |
| `<leader>e` | nvim-tree로 포커스 |
| `<leader>ff` / `fw` / `fb` / `fo` | 파일 찾기 / 텍스트 검색(live grep) / 버퍼 / 최근 파일 |

nvim-tree 안에서: `a` 새 파일(끝에 `/`면 디렉토리), `r` rename, `d` delete, `c`/`p` 복사/붙여넣기, `g?` 도움말

### LSP

| 키 | 동작 |
|---|---|
| `gd` / `gr` | 정의로 이동 / 참조 목록 |
| `K` | hover 문서 |
| `<leader>ca` | code action |
| `<leader>ra` | rename (커스텀 — NvChad 기본 대체) |
| `[d` / `]d` | 이전 / 다음 diagnostic |
| `<leader>fm` | 포맷 (conform — python은 isort → black 순서) |

### Git

| 키 | 동작 |
|---|---|
| `<leader>gg` / `gf` | lazygit / 현재 파일 lazygit |
| `<leader>gd` | diffview 토글 (열려 있으면 닫힘) |
| `<leader>gh` | 현재 파일 히스토리 (diffview) |
| `<leader>gb` | 커서 라인 inline blame 토글 (기본 on) |
| `<leader>gB` | blame 팝업 (커밋 메시지 전체 + hunk) |
| `<leader>gc` | 현재 라인의 커밋을 diffview로 열기 |

diffview 안에서: `<leader>b` 파일 패널 토글, `<leader>gd` 또는 `:DiffviewClose`로 닫기

### 디버깅 (dap)

| 키 | 동작 |
|---|---|
| `<leader>db` | breakpoint 토글 |
| `<leader>dc` | continue / 세션 시작 (launch config 선택) |
| `<leader>di` / `do` / `dO` | step into / over / out |
| `<leader>dq` | 세션 종료 |
| `<leader>du` | dap-ui 토글 |

### 테스트 (neotest)

| 키 | 동작 |
|---|---|
| `<leader>tr` | 커서 위치 nearest test 실행 |
| `<leader>tf` | 현재 파일 전체 실행 |
| `<leader>td` | nearest test를 debugpy로 디버깅 |
| `<leader>ts` | summary 트리 토글 |
| `<leader>to` | 테스트 output 팝업 |

### venv / 세션 / 폴딩

| 키 | 동작 |
|---|---|
| `<leader>vs` | venv 선택 → pyright + dap 경로 전환 |
| `<leader>qs` / `ql` | 세션 복원 (cwd / 마지막) |
| `<leader>qd` | 이번 세션 저장 안 함 |
| `za` / `zc` / `zo` | 폴드 토글 / 닫기 / 열기 |
| `zM` / `zR` | 전체 접기 / 전체 펼치기 |
| `zm` / `zr` | 레벨 단위 접기 / 펼치기 |

정의 위치: 커스텀은 `lua/mappings.lua` + `lua/plugins/init.lua`의 `keys`, NvChad 기본은 `:h nvchad.mappings`

## 구조

```
init.lua                  -- lazy.nvim bootstrap
lua/chadrc.lua            -- NvChad 테마/statusline (venv 모듈)
lua/options.lua           -- 폴딩 등 vim 옵션
lua/mappings.lua          -- 커스텀 키맵
lua/autocmds.lua
lua/plugins/init.lua      -- 플러그인 spec 전부
lua/configs/dap.lua       -- dap-ui 레이아웃 + Django/FastAPI launch config
lua/configs/lspconfig.lua -- pyright, ruff, html, cssls
lua/configs/conform.lua   -- 포매터
lazy-lock.json            -- 플러그인 버전 고정 (커밋 유지)
```

## Credits

- [NvChad](https://github.com/NvChad/NvChad) / [NvChad starter](https://github.com/NvChad/starter)
