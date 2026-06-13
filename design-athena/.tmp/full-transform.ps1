$ErrorActionPreference = "Stop"
$out = "C:\Users\90949\myprojects\Athena\design-athena\chat.html"

# ===== CSS CHANGES =====
$c = Get-Content $out -Raw -Encoding UTF8

# 1.1 Viewport + title
$c = $c.Replace('<meta name="viewport" content="width=device-width, initial-scale=1" />', '')
$c = $c.Replace('<title>对话 · Athena</title>', '<title>Athena</title>')

# 1.2 Root tokens
$c = $c.Replace('--radius-sm: 9999px;', '--radius-sm: 4px;')
$c = $c.Replace('--sidebar-w: 280px;', '--sidebar-w: 260px;')
$c = $c.Replace('--sidebar-w: 260px;', '--sidebar-w: 260px;
      --titlebar-h: 38px;
      --statusbar-h: 26px;
      --activitybar-w: 48px;')

# 1.3 Body font-size
$c = $c.Replace('font-size: 15px;', 'font-size: 14px;')

# 1.4 Add light theme overrides for statusbar/activitybar
$c = $c.Replace(
  '[data-theme="light"] .settings-modal-content .setting-card { box-shadow: rgba(0,0,0,0.04) 0px 2px 8px; }',
  '[data-theme="light"] .settings-modal-content .setting-card { box-shadow: rgba(0,0,0,0.04) 0px 2px 8px; }
    [data-theme="light"] .statusbar { border-top-color: rgba(0,0,0,0.08); }
    [data-theme="light"] .activitybar { border-right-color: rgba(0,0,0,0.08); }'
)

# 1.5 Replace theme-toggle CSS (remove it - theme toggle moves to activitybar)
$c = $c.Replace(
  @"
    .theme-toggle {
      width: 32px; height: 32px;
      border: none; background: var(--surface-warm);
      border-radius: 50%; color: var(--muted);
      display: grid; place-items: center;
      cursor: pointer;
      transition: var(--motion-fast) var(--ease-standard);
    }
    .theme-toggle:hover { background: var(--border-soft); color: var(--fg); }
"@,
  ""
)

# 1.6 Replace .topbar with .titlebar
$c = $c.Replace(
  @"
    .topbar {
      display: flex; align-items: center; justify-content: space-between;
      padding: 10px 20px;
      background: var(--surface);
      border-bottom: 1px solid var(--border-soft);
      box-shadow: none;
      position: relative;
      z-index: 20;
      flex-shrink: 0;
    }
    .topbar-left { display: flex; align-items: center; gap: 14px; }
    .topbar-brand {
      font-family: var(--font-display);
      font-size: 18px;
      font-weight: 600;
      letter-spacing: -0.02em;
      display: flex; align-items: center; gap: 8px;
    }
    .topbar-brand svg { width: 22px; height: 22px; }
    .topbar-nav { display: flex; gap: 20px; }
    .topbar-nav a {
      font-size: 13px;
      color: var(--fg-2);
      text-decoration: none;
      padding: 4px 0;
      border-bottom: 2px solid transparent;
      transition: var(--motion-fast) var(--ease-standard);
    }
    .topbar-nav a:hover { color: var(--fg); }
    .topbar-nav a.active { color: var(--accent); border-bottom-color: var(--accent); }
    .topbar-right {
      display: flex; align-items: center; gap: 10px;
      font-size: 13px;
      color: var(--fg-2);
    }
"@,
  @"
    .titlebar {
      height: var(--titlebar-h);
      display: flex; align-items: center; justify-content: space-between;
      padding: 0 12px;
      background: var(--surface);
      border-bottom: 1px solid var(--border-soft);
      flex-shrink: 0;
      -webkit-app-region: drag;
      user-select: none;
    }
    .titlebar-left { display: flex; align-items: center; gap: 12px; -webkit-app-region: no-drag; }
    .titlebar-brand {
      font-family: var(--font-display);
      font-size: 13px;
      font-weight: 600;
      letter-spacing: -0.01em;
      display: flex; align-items: center; gap: 7px;
      -webkit-app-region: drag;
    }
    .titlebar-brand svg { width: 18px; height: 18px; }
    .window-controls { display: flex; align-items: center; gap: 8px; -webkit-app-region: no-drag; }
    .wc-btn { width: 14px; height: 14px; border-radius: 50%; border: none; cursor: pointer; transition: opacity var(--motion-fast) var(--ease-standard); }
    .wc-btn:hover { opacity: 0.85; }
    .wc-close { background: #ff5f57; }
    .wc-minimize { background: #febc2e; }
    .wc-maximize { background: #28c840; }
    .titlebar-center { flex: 1; display: flex; align-items: center; justify-content: center; -webkit-app-region: no-drag; }
    .titlebar-right { display: flex; align-items: center; gap: 8px; -webkit-app-region: no-drag; }
"@
)

# 1.7 Shrink agent-trigger + remove @media for tab-hint
$c = $c.Replace(
  @'
    .agent-trigger {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 5px 12px 5px 10px;
      background: rgba(30, 215, 96, 0.1);
      border: 1px solid transparent;
      border-radius: var(--radius-pill);
      cursor: pointer;
      font-family: var(--font-body);
      font-size: 13px;
      font-weight: 500;
      color: var(--accent);
      transition: var(--motion-fast) var(--ease-standard);
    }
    .agent-trigger:hover {
      background: rgba(30, 215, 96, 0.15);
    }
    .agent-trigger .agent-avatar {
      width: 22px; height: 22px;
      border-radius: 50%;
      background: var(--accent);
      color: var(--accent-on);
      display: grid; place-items: center;
      font-size: 11px;
      font-weight: 700;
    }
    .agent-trigger .agent-arrow {
      font-size: 10px;
      opacity: 0.6;
      margin-left: 2px;
    }
    .tab-hint {
      font-size: 10px;
      color: var(--muted);
      background: var(--surface-warm);
      padding: 2px 8px;
      border-radius: var(--radius-pill);
      display: none;
    }
    @media (min-width: 900px) { .tab-hint { display: inline; } }
'@,
  @'
    .agent-trigger {
      display: flex;
      align-items: center;
      gap: 7px;
      padding: 4px 10px 4px 8px;
      background: rgba(30, 215, 96, 0.08);
      border: 1px solid transparent;
      border-radius: var(--radius-pill);
      cursor: pointer;
      font-family: var(--font-body);
      font-size: 12px;
      font-weight: 500;
      color: var(--accent);
      transition: var(--motion-fast) var(--ease-standard);
    }
    .agent-trigger:hover {
      background: rgba(30, 215, 96, 0.14);
    }
    .agent-trigger .agent-avatar {
      width: 20px; height: 20px;
      border-radius: 50%;
      background: var(--accent);
      color: var(--accent-on);
      display: grid; place-items: center;
      font-size: 10px;
      font-weight: 700;
    }
    .agent-trigger .agent-arrow {
      font-size: 9px;
      opacity: 0.5;
      margin-left: 1px;
    }
    .tab-hint {
      font-size: 9px;
      color: var(--muted);
      background: var(--surface-warm);
      padding: 1px 6px;
      border-radius: var(--radius-pill);
    }
'@
)

# 1.8 Simplify .btn-new
$c = $c.Replace(
  @"
    .sidebar-head .btn-new {
      width: 100%;
      padding: 10px;
      background: var(--accent);
      color: var(--accent-on);
      border: none;
      border-radius: var(--radius-pill);
      font-family: var(--font-body);
      font-size: 14px;
      font-weight: 700;
      cursor: pointer;
      transition: var(--motion-fast) var(--ease-standard);
      box-shadow: none;
      text-transform: uppercase;
      letter-spacing: 1.4px;
    }
"@,
  @"
    .sidebar-head .btn-new {
      flex: 1;
      padding: 7px 10px;
      background: var(--accent);
      color: var(--accent-on);
      border: none;
      border-radius: var(--radius-md);
      font-family: var(--font-body);
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: var(--motion-fast) var(--ease-standard);
    }
"@
)

# 1.9 Add sidebar-wrapper, collapse, resize
$c = $c.Replace(
  @"
    .sidebar {
      width: var(--sidebar-w);
      background: var(--surface);
      border-right: 1px solid var(--border-soft);
      display: flex;
      flex-direction: column;
      flex-shrink: 0;
    }
"@,
  @"
    .sidebar-wrapper {
      display: flex;
      flex-shrink: 0;
    }
    .sidebar {
      width: var(--sidebar-w);
      background: var(--surface);
      border-right: 1px solid var(--border-soft);
      display: flex;
      flex-direction: column;
      transition: width var(--motion-base) var(--ease-standard);
      overflow: hidden;
    }
    .sidebar.collapsed { width: 0; border-right: none; }
    .sidebar-collapse-btn {
      width: 28px; height: 28px;
      background: none; border: 1px solid var(--border-soft);
      border-radius: var(--radius-sm);
      color: var(--muted);
      display: grid; place-items: center;
      cursor: pointer;
      transition: var(--motion-fast) var(--ease-standard);
      flex-shrink: 0;
    }
    .sidebar-collapse-btn:hover { background: var(--surface-warm); color: var(--fg); }
    .sidebar-resize {
      width: 4px;
      cursor: col-resize;
      background: transparent;
      transition: background var(--motion-fast) var(--ease-standard);
      flex-shrink: 0;
    }
    .sidebar-resize:hover,
    .sidebar-resize.active { background: var(--accent); }
"@
)

# 1.10 Add activitybar CSS
$old = "    .sidebar-head {"
$new = @"
    .activitybar {
      width: var(--activitybar-w);
      background: var(--surface);
      border-right: 1px solid var(--border-soft);
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      padding: 6px;
      gap: 2px;
      flex-shrink: 0;
    }
    .ab-btn {
      width: 36px; height: 36px;
      background: none; border: none;
      border-radius: var(--radius-md);
      color: var(--muted);
      display: grid; place-items: center;
      cursor: pointer;
      transition: var(--motion-fast) var(--ease-standard);
    }
    .ab-btn:hover { background: var(--surface-warm); color: var(--fg); }
    .ab-btn.active { color: var(--accent); background: rgba(30, 215, 96, 0.08); }
    .ab-btn svg { width: 18px; height: 18px; }
    .ab-spacer { flex: 1; }

    .sidebar-head {
"@
$c = $c.Replace($old, $new)

# 1.11 Simplify input-area
$c = $c.Replace(
  @"
    .input-area {
      margin: 0 16px 16px;
      padding: 10px 14px 12px;
      background: var(--surface);
      border-radius: var(--radius-lg);
      box-shadow: var(--elev-raised);
      flex-shrink: 0;
      position: relative;
      transition: var(--motion-base) var(--ease-standard);
      border: 2px solid transparent;
    }
"@,
  @"
    .input-area {
      padding: 8px 12px 10px;
      border-top: 1px solid var(--border-soft);
      flex-shrink: 0;
      position: relative;
    }
"@
)

# 1.12 Make send-btn square
$c = $c.Replace(
  @"
    .send-btn {
      width: 38px; height: 38px;
      border: none;
      background: var(--accent);
      color: var(--accent-on);
      border-radius: 50%;
      cursor: pointer;
      display: grid; place-items: center;
      transition: var(--motion-fast) var(--ease-standard);
      flex-shrink: 0;
      box-shadow: none;
    }
"@,
  @"
    .send-btn {
      width: 34px; height: 34px;
      border: none;
      background: var(--accent);
      color: var(--accent-on);
      border-radius: var(--radius-md);
      cursor: pointer;
      display: grid; place-items: center;
      transition: var(--motion-fast) var(--ease-standard);
      flex-shrink: 0;
    }
"@
)

# 1.13 Scrollbar update
$c = $c.Replace(
  @"
    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
    ::-webkit-scrollbar-thumb:hover { background: var(--muted); }
"@,
  @"
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.12); border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.2); }
    [data-theme="light"] ::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.12); }
    [data-theme="light"] ::-webkit-scrollbar-thumb:hover { background: rgba(0,0,0,0.2); }
"@
)

# 1.14 Remove @media (max-width: 768px)
$c = $c.Replace(
  @"
    @media (max-width: 768px) {
      .sidebar { display: none; }
      .input-area { margin: 0 10px 12px; }
      .chat-messages { padding: 16px 12px; }
      .modal-panel.modal-settings,
      .modal-panel.modal-history { width: 98vw; height: 90vh; }
      .settings-modal-nav { width: 56px; }
      .settings-modal-nav .smn-item span { display: none; }
      .settings-modal-nav .smn-label { display: none; }
      .settings-modal-nav .smn-item { justify-content: center; padding: 10px; }
    }
"@,
  ""
)

# 1.15 Add context-menu + statusbar CSS
$c = $c.Replace(
  "    .field-group {",
  @'
    .context-menu {
      display: none;
      position: fixed;
      background: var(--surface);
      border: 1px solid var(--border-soft);
      border-radius: var(--radius-md);
      box-shadow: var(--elev-modal);
      min-width: 160px;
      z-index: 200;
      padding: 4px 0;
      font-size: 12px;
    }
    .context-menu.open { display: block; }
    .context-menu-item {
      display: flex; align-items: center; gap: 8px;
      padding: 6px 12px;
      cursor: pointer;
      color: var(--fg-2);
      transition: var(--motion-fast) var(--ease-standard);
    }
    .context-menu-item:hover { background: var(--surface-warm); color: var(--fg); }
    .context-menu-item.danger { color: var(--danger); }
    .context-menu-item.danger:hover { background: rgba(243, 114, 127, 0.1); }
    .context-menu-item svg { width: 14px; height: 14px; flex-shrink: 0; }
    .context-menu-divider { height: 1px; background: var(--border-soft); margin: 3px 0; }
    .context-menu-item .cm-shortcut {
      margin-left: auto; font-size: 10px; color: var(--muted);
      font-family: var(--font-mono);
    }

    .statusbar {
      height: var(--statusbar-h);
      background: var(--surface);
      border-top: 1px solid var(--border-soft);
      display: flex; align-items: center;
      padding: 0 12px;
      font-size: 11px;
      color: var(--muted);
      gap: 16px;
      flex-shrink: 0;
    }
    .statusbar-left { display: flex; align-items: center; gap: 14px; }
    .statusbar-right { margin-left: auto; display: flex; align-items: center; gap: 14px; }
    .sb-dot {
      width: 6px; height: 6px; border-radius: 50%; background: var(--success);
      display: inline-block; margin-right: 4px;
    }
    .sb-item { display: flex; align-items: center; gap: 4px; }
    .sb-item kbd {
      background: var(--surface-warm); border: 1px solid var(--border-soft);
      border-radius: 3px; padding: 0 4px; font-size: 10px;
      font-family: var(--font-mono); line-height: 1.6;
    }
    .sb-model {
      font-family: var(--font-mono); color: var(--fg-2);
    }
    .sb-tokens { font-family: var(--font-mono); }

    .field-group {
'@
)

Write-Output "CSS: done, $($c.Length) chars"

# ===== HTML CHANGES =====

# 2.1 Replace <header class="topbar"> with <div class="titlebar">
$c = $c.Replace(
  @'
  <header class="topbar">
    <div class="topbar-left">
      <div class="topbar-brand">
        <svg viewBox="0 0 28 28" fill="none"><rect x="2" y="2" width="24" height="24" rx="8" style="fill:var(--accent)"/><path d="M8 14l4 4 8-8" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        Athena
      </div>
      <nav class="topbar-nav">
        <span class="active" style="font-size:13px;padding:4px 0;border-bottom:2px solid var(--accent);color:var(--accent);">对话</span>
        <a href="#" onclick="openModal('settings');return false;" style="font-size:13px;color:var(--fg-2);padding:4px 0;border-bottom:2px solid transparent;transition:var(--motion-fast) var(--ease-standard);">设置</a>
        <a href="#" onclick="openModal('history');return false;" style="font-size:13px;color:var(--fg-2);padding:4px 0;border-bottom:2px solid transparent;transition:var(--motion-fast) var(--ease-standard);">历史</a>
      </nav>
    </div>
    <div class="topbar-right">
      <div class="agent-selector" id="agentSelector">
        <div class="agent-trigger" onclick="toggleAgentDropdown()">
          <span class="agent-avatar" id="agentTriggerAvatar">A</span>
          <span id="agentTriggerName">全能辅助</span>
          <span class="tab-hint">Tab 切换</span>
          <span class="agent-arrow">▾</span>
        </div>
        <div class="agent-dropdown" id="agentDropdown">
          <div class="agent-dropdown-head">主代理</div>
          <div id="agentDropdownList">
          </div>
        </div>
      </div>

      <div class="token-panel" id="tokenPanel">
        <div class="token-trigger" onclick="toggleTokenDropdown()">
          <span class="tt-dot"></span>
          <span id="tokenTriggerText">3.2K / 128K</span>
        </div>
        <div class="token-dropdown" id="tokenDropdown">
          <div class="td-title">本轮对话 Token 消耗</div>
          <div class="token-breakdown" id="tokenBreakdown">
          </div>
          <div class="td-bar"><div class="td-fill" id="tdFill" style="width:2.5%"></div></div>
          <div class="td-footer">
            <span id="tdModelCount">3 个模型</span>
            <span id="tdCost">估算成本: $0.024</span>
          </div>
        </div>
        <button class="theme-toggle" onclick="toggleTheme()" title="切换浅色/深色模式">
          <svg id="themeIcon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
        </button>
      </div>
    </div>
  </header>
'@,
  @'
  <div class="titlebar">
    <div class="titlebar-left">
      <div class="window-controls">
        <button class="wc-btn wc-close" title="关闭"></button>
        <button class="wc-btn wc-minimize" title="最小化"></button>
        <button class="wc-btn wc-maximize" title="最大化"></button>
      </div>
      <div class="titlebar-brand">
        <svg viewBox="0 0 28 28" fill="none"><rect x="2" y="2" width="24" height="24" rx="6" style="fill:var(--accent)"/><path d="M8 14l4 4 8-8" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
        Athena
      </div>
    </div>

    <div class="titlebar-center">
      <div class="agent-selector" id="agentSelector">
        <div class="agent-trigger" onclick="toggleAgentDropdown()">
          <span class="agent-avatar" id="agentTriggerAvatar">A</span>
          <span id="agentTriggerName">全能辅助</span>
          <span class="tab-hint">Tab</span>
          <span class="agent-arrow">▾</span>
        </div>
        <div class="agent-dropdown" id="agentDropdown">
          <div class="agent-dropdown-head">主代理</div>
          <div id="agentDropdownList">
          </div>
        </div>
      </div>
    </div>

    <div class="titlebar-right">
      <div class="token-panel" id="tokenPanel">
        <div class="token-trigger" onclick="toggleTokenDropdown()">
          <span class="tt-dot"></span>
          <span id="tokenTriggerText">3.2K / 128K</span>
        </div>
        <div class="token-dropdown" id="tokenDropdown">
          <div class="td-title">本轮对话 Token 消耗</div>
          <div class="token-breakdown" id="tokenBreakdown">
          </div>
          <div class="td-bar"><div class="td-fill" id="tdFill" style="width:2.5%"></div></div>
          <div class="td-footer">
            <span id="tdModelCount">3 个模型</span>
            <span id="tdCost">估算成本: $0.024</span>
          </div>
        </div>
      </div>
    </div>
  </div>
'@
)
Write-Output "HTML titlebar: done"

# 2.2 Wrap sidebar, add collapse btn, add resize handle
$c = $c.Replace(
  @'
    <aside class="sidebar" data-od-id="sidebar">
      <div class="sidebar-head">
        <button class="btn-new" onclick="newConversation()">+ 新对话</button>
      </div>
'@,
  @'
  <div class="sidebar-wrapper">
      <aside class="sidebar" id="sidebar" data-od-id="sidebar">
        <div class="sidebar-head">
          <button class="btn-new" onclick="newConversation()">新对话</button>
          <button class="sidebar-collapse-btn" onclick="toggleSidebar()" title="折叠侧栏 (Ctrl+B)">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="15 18 9 12 15 6"/></svg>
          </button>
        </div>
'@
)

# 2.3 Close sidebar-wrapper + add activitybar before chat-main
$c = $c.Replace(
  @'
    </aside>

    <div class="chat-main" data-od-id="chat-main">
'@,
  @'
      </aside>
      <div class="sidebar-resize" id="sidebarResize"></div>
    </div>

    <nav class="activitybar">
      <button class="ab-btn" onclick="toggleSidebar()" title="切换侧栏 (Ctrl+B)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><rect x="3" y="3" width="18" height="18" rx="2"/><line x1="9" y1="3" x2="9" y2="21"/></svg>
      </button>
      <div class="ab-spacer"></div>
      <button class="ab-btn" onclick="openModal('history')" title="历史记录 (Ctrl+K)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
      </button>
      <button class="ab-btn" onclick="toggleTheme()" title="切换主题">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
      </button>
      <button class="ab-btn" onclick="openModal('settings')" title="设置 (Ctrl+,)">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-2 2 2 2 0 01-2-2v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83 0 2 2 0 010-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 01-2-2 2 2 0 012-2h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 010-2.83 2 2 0 012.83 0l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 012-2 2 2 0 012 2v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 0 2 2 0 010 2.83l-.06.06a1.65 1.65 0 00-.33 1.82V9a1.65 1.65 0 001.51 1H21a2 2 0 012 2 2 2 0 01-2 2h-.09a1.65 1.65 0 00-1.51 1z"/></svg>
      </button>
    </nav>

    <div class="chat-main" data-od-id="chat-main">
'@
)
Write-Output "HTML sidebar+activity: done"

# 2.4 Add statusbar + context menus before modal
$c = $c.Replace(
  @'
  <div class="modal-overlay" id="modal-settings" onclick="if(event.target===this)closeModal('settings')">
'@,
  @'
  <div class="statusbar">
    <div class="statusbar-left">
      <span class="sb-item"><span class="sb-dot"></span>已连接</span>
      <span class="sb-item sb-model" id="sbModel">DeepSeek V3</span>
    </div>
    <div class="statusbar-right">
      <span class="sb-item sb-tokens" id="sbTokens">3.2K / 128K</span>
      <span class="sb-item"><kbd>Ctrl+N</kbd> 新对话</span>
      <span class="sb-item"><kbd>Ctrl+K</kbd> 搜索</span>
      <span class="sb-item"><kbd>Ctrl+,</kbd> 设置</span>
    </div>
  </div>

  <div class="context-menu" id="contextMenu">
    <div class="context-menu-item" onclick="contextAction('copy')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
      复制 <span class="cm-shortcut">Ctrl+C</span>
    </div>
    <div class="context-menu-item" onclick="contextAction('copyContent')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><path d="M14 2v6h6"/></svg>
      复制纯文本
    </div>
    <div class="context-menu-divider"></div>
    <div class="context-menu-item" onclick="contextAction('regenerate')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 11-2.12-9.36L23 10"/></svg>
      重新生成
    </div>
    <div class="context-menu-divider"></div>
    <div class="context-menu-item danger" onclick="contextAction('delete')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/></svg>
      删除消息
    </div>
  </div>

  <div class="context-menu" id="convContextMenu">
    <div class="context-menu-item" onclick="convContextAction('rename')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
      重命名
    </div>
    <div class="context-menu-item" onclick="convContextAction('pin')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="17" x2="12" y2="22"/><path d="M5 17h14v-1.76a2 2 0 00-1.11-1.79l-1.78-.9A2 2 0 0115 10.76V6h1a2 2 0 000-4H8a2 2 0 000 4h1v4.76a2 2 0 01-1.11 1.79l-1.78.9A2 2 0 005 15.24z"/></svg>
      置顶
    </div>
    <div class="context-menu-divider"></div>
    <div class="context-menu-item danger" onclick="convContextAction('delete')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/></svg>
      删除对话
    </div>
  </div>

  <div class="modal-overlay" id="modal-settings" onclick="if(event.target===this)closeModal('settings')">
'@
)
Write-Output "HTML statusbar+menus: done"

# 2.5 Add oncontextmenu to messages
$c = $c.Replace('<div class="msg assistant">', '<div class="msg assistant" oncontextmenu="showMsgContextMenu(event, this)">')
$c = $c.Replace('<div class="msg user">', '<div class="msg user" oncontextmenu="showMsgContextMenu(event, this)">')

# 2.6 Update welcome message
$c = $c.Replace(
  '按 <kbd>Tab</kbd> 可以切换到其他主代理，对话上下文保持不变。',
  '按 <kbd>Tab</kbd> 切换主代理，<kbd>Ctrl+,</kbd> 打开设置，<kbd>Ctrl+N</kbd> 新建对话。'
)

# ===== JS CHANGES =====

# 3.1 Simplify toggleTheme, remove updateThemeIcon
$c = $c.Replace(
  @'
    function toggleTheme() {
      var html = document.documentElement;
      var current = html.getAttribute('data-theme') || 'dark';
      var next = current === 'dark' ? 'light' : 'dark';
      html.setAttribute('data-theme', next);
      localStorage.setItem('athena-theme', next);
      updateThemeIcon();
    }
    function updateThemeIcon() {
      var theme = document.documentElement.getAttribute('data-theme') || 'dark';
      var icon = document.getElementById('themeIcon');
      if (!icon) return;
      if (theme === 'light') {
        icon.innerHTML = '<circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>';
      } else {
        icon.innerHTML = '<path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/>';
      }
    }
'@,
  @'
    function toggleTheme() {
      var html = document.documentElement;
      var current = html.getAttribute('data-theme') || 'dark';
      var next = current === 'dark' ? 'light' : 'dark';
      html.setAttribute('data-theme', next);
      localStorage.setItem('athena-theme', next);
    }
'@
)

# 3.2 Add keyboard shortcuts
$c = $c.Replace(
  @"
        switchAgent(state.primaryAgents[nextIdx].id);
      }
    });
"@,
  @"
        switchAgent(state.primaryAgents[nextIdx].id);
      }
      if ((e.ctrlKey || e.metaKey) && e.key === ',') { e.preventDefault(); openModal('settings'); }
      if ((e.ctrlKey || e.metaKey) && e.key === 'n') { e.preventDefault(); newConversation(); }
      if ((e.ctrlKey || e.metaKey) && e.key === 'k') { e.preventDefault(); openModal('history'); }
      if ((e.ctrlKey || e.metaKey) && e.key === 'b') { e.preventDefault(); toggleSidebar(); }
    });
"@
)

# 3.3 Update switchAgent to also set sbModel
$c = $c.Replace(
  "      document.getElementById('agentTriggerName').textContent = next.name;",
  "      document.getElementById('agentTriggerName').textContent = next.name;`n      document.getElementById('sbModel').textContent = next.model;"
)

# 3.4 Update renderTokenPanel to also set sbTokens
$c = $c.Replace(
  "      document.getElementById('tokenTriggerText').textContent =`n        display;",
  "      document.getElementById('tokenTriggerText').textContent =`n        display;`n      document.getElementById('sbTokens').textContent = display;"
)

# 3.5 Add new functions before `renderAgentDropdown()`
$c = $c.Replace(
  "    renderAgentDropdown();",
  @'
    function toggleSidebar() {
      document.getElementById('sidebar').classList.toggle('collapsed');
    }

    const sidebarResize = document.getElementById('sidebarResize');
    let isResizing = false;
    sidebarResize.addEventListener('mousedown', function(e) {
      isResizing = true;
      sidebarResize.classList.add('active');
      document.body.style.cursor = 'col-resize';
      document.body.style.userSelect = 'none';
      e.preventDefault();
    });
    document.addEventListener('mousemove', function(e) {
      if (!isResizing) return;
      const activitybar = document.querySelector('.activitybar');
      const totalLeft = activitybar.offsetWidth;
      const newWidth = Math.max(180, Math.min(e.clientX - totalLeft, 400));
      document.getElementById('sidebar').style.width = newWidth + 'px';
    });
    document.addEventListener('mouseup', function() {
      if (isResizing) {
        isResizing = false;
        sidebarResize.classList.remove('active');
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
      }
    });

    let activeContextMenu = null;
    function closeAllContextMenus() {
      document.querySelectorAll('.context-menu.open').forEach(function(m) { m.classList.remove('open'); });
      activeContextMenu = null;
    }
    function showMsgContextMenu(e, el) {
      e.preventDefault();
      closeAllContextMenus();
      const menu = document.getElementById('contextMenu');
      activeContextMenu = { type: 'message', element: el };
      menu.style.left = e.clientX + 'px';
      menu.style.top = e.clientY + 'px';
      menu.classList.add('open');
    }
    function contextAction(action) {
      closeAllContextMenus();
      if (action === 'copy' || action === 'copyContent') {
        if (activeContextMenu && activeContextMenu.element) {
          navigator.clipboard.writeText(activeContextMenu.element.textContent || '').then(function() { showToast('已复制'); });
        }
      } else if (action === 'regenerate') {
        showToast('重新生成...');
      } else if (action === 'delete') {
        if (activeContextMenu && activeContextMenu.element) {
          activeContextMenu.element.remove();
          showToast('已删除');
        }
      }
    }
    function convContextAction(action) {
      closeAllContextMenus();
      if (action === 'rename') { showToast('重命名...'); }
      else if (action === 'pin') { showToast('已置顶'); }
      else if (action === 'delete') {
        if (activeContextMenu && activeContextMenu.element) {
          activeContextMenu.element.remove();
          showToast('已删除');
        }
      }
    }

    document.querySelectorAll('.conv-item').forEach(function(item) {
      item.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        closeAllContextMenus();
        const menu = document.getElementById('convContextMenu');
        activeContextMenu = { type: 'conv', element: this };
        menu.style.left = e.clientX + 'px';
        menu.style.top = e.clientY + 'px';
        menu.classList.add('open');
      });
    });

    document.addEventListener('contextmenu', function(e) {
      if (!e.target.closest('.msg') && !e.target.closest('.conv-item')) {
        closeAllContextMenus();
      }
    });

    renderAgentDropdown();
'@
)

# 3.6 Update sendMessage to add oncontextmenu
$c = $c.Replace(
  "      userMsg.className = 'msg user';",
  "      userMsg.className = 'msg user';`n      userMsg.setAttribute('oncontextmenu', 'showMsgContextMenu(event, this)');"
)
$c = $c.Replace(
  "        aiMsg.className = 'msg assistant';",
  "        aiMsg.className = 'msg assistant';`n        aiMsg.setAttribute('oncontextmenu', 'showMsgContextMenu(event, this)');"
)

# 3.7 Escape handler: add closeAllContextMenus
$c = $c.Replace(
  "        closeAllModals();`n        closeAgentDropdown();",
  "        closeAllModals();`n        closeAgentDropdown();`n        closeAllContextMenus();"
)

# 3.8 Global click handler: add closeAllContextMenus
$c = $c.Replace(
  "    document.addEventListener('click', function(e) {`n      const agentSel = document.getElementById('agentSelector');`n      if (!agentSel.contains(e.target)) closeAgentDropdown();",
  "    document.addEventListener('click', function(e) {`n      closeAllContextMenus();`n      const agentSel = document.getElementById('agentSelector');`n      if (!agentSel.contains(e.target)) closeAgentDropdown();"
)

# 3.9 Update toast position
$c = $c.Replace('bottom: 24px;', 'bottom: 40px;')

Write-Output "JS: done, $($c.Length) chars"

# ==== Write back ====
Set-Content $out -Value $c -Encoding UTF8 -NoNewline
Write-Output "WRITTEN. Final: $($c.Length) chars"
