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

## 주요 키맵

| 키 | 동작 |
|---|---|
| `<leader>gg` / `gf` | lazygit / 현재 파일 lazygit |
| `<leader>gd` / `gh` | diffview 토글 / 파일 히스토리 |
| `<leader>gb` / `gB` / `gc` | 라인 blame 토글 / blame 팝업 / 현재 라인 커밋 열기 |
| `<leader>db` `dc` `di` `do` `dO` `dq` `du` | breakpoint / continue / step into·over·out / 종료 / UI 토글 |
| `<leader>tr` `tf` `td` `ts` `to` | nearest test / 파일 / 디버그 / summary / output |
| `<leader>vs` | venv 선택 |
| `<leader>x` | 버퍼 닫기 (레이아웃 유지) |
| `<Tab>` / `<S-Tab>` | 버퍼 이동 |
| `<leader>qs` / `ql` | 세션 복원 (cwd / last) |
| `za` `zM` `zR` | 폴드 토글 / 전체 접기 / 전체 펼치기 |

전체 목록: `lua/mappings.lua`, `lua/plugins/init.lua`의 `keys`

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
