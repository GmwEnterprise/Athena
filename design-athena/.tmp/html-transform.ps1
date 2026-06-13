$ErrorActionPreference = "Stop"
$f = "C:\Users\90949\myprojects\Athena\design-athena\chat.html"
$c = Get-Content $f -Raw -Encoding UTF8

# 1. Replace header.topbar with div.titlebar
$oldHeader = '<header class="topbar">'
if ($c.Contains($oldHeader)) {
  # Find the full header block from <header class="topbar"> to </header>
  $startIdx = $c.IndexOf($oldHeader)
  $endIdx = $c.IndexOf('</header>', $startIdx) + '</header>'.Length
  $oldHeaderFull = $c.Substring($startIdx, $endIdx - $startIdx)
  
  $newTitlebar = @'
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
  $c = $c.Replace($oldHeaderFull, $newTitlebar)
  Write-Output "Titlebar replaced OK"
} else {
  Write-Output "WARNING: oldHeader not found"
  
  $alreadyHas = $c.Contains('<div class="titlebar">')
  Write-Output "Has titlebar div: $alreadyHas"
}

# 2. Wrap sidebar in sidebar-wrapper
$oldSidebarStart = '<aside class="sidebar" data-od-id="sidebar">'
if ($c.Contains($oldSidebarStart)) {
  $newSidebarStart = @'
<div class="sidebar-wrapper">
      <aside class="sidebar" id="sidebar" data-od-id="sidebar">
        <div class="sidebar-head">
          <button class="btn-new" onclick="newConversation()">新对话</button>
          <button class="sidebar-collapse-btn" onclick="toggleSidebar()" title="折叠侧栏 (Ctrl+B)">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="15 18 9 12 15 6"/></svg>
          </button>
        </div>
'@
  $c = $c.Replace($oldSidebarStart, $newSidebarStart)
  Write-Output "Sidebar start replaced"
}

# Also replace the sidebar head content within the wrapper
$oldSidebarHeadBtn = '<button class="btn-new" onclick="newConversation()">+ 新对话</button>'
$c = $c.Replace($oldSidebarHeadBtn, '<button class="btn-new" onclick="newConversation()">新对话</button>')

# 3. Add activitybar before chat-main
$oldChatMain = '<div class="chat-main" data-od-id="chat-main">'
$newChatMain = @'
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

# Close the sidebar-aside first (it's currently `</aside>`)
# Find the `</aside>` before `chat-main`
$chatMainIdx = $c.IndexOf($oldChatMain)
if ($chatMainIdx -gt 0) {
  # Find the last </aside> before chat-main
  $before = $c.Substring(0, $chatMainIdx)
  $lastAsideEndIdx = $before.LastIndexOf('</aside>')
  if ($lastAsideEndIdx -gt 0) {
    $preAside = $c.Substring(0, $lastAsideEndIdx)
    $postAsideStart = $lastAsideEndIdx + '</aside>'.Length
    # Remove the </aside> that closes the sidebar, replace with new structure
    $afterAside = $c.Substring($postAsideStart)
    $c = $preAside + $newChatMain + $afterAside.Substring($oldChatMain.Length)
    Write-Output "Activitybar + sidebar-resize added"
  } else {
    Write-Output "WARNING: Could not find </aside> before chat-main"
  }
} else {
  Write-Output "WARNING: chat-main not found"
}

# 4. Add statusbar + context menus before the settings modal
$oldModalSettingsStart = '<div class="modal-overlay" id="modal-settings"'
if ($c.Contains($oldModalSettingsStart)) {
  $statusbarBlock = @'
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

  <div class="modal-overlay" id="modal-settings"'
'@
  $c = $c.Replace($oldModalSettingsStart, $statusbarBlock)
  Write-Output "Statusbar + context menus added"
} else {
  Write-Output "WARNING: modal-settings not found"
  # Try finding it with single quotes
  $c2 = $c.Replace("modal-settings", "Xmodal-settings")
  if ($c2 -ne $c) {
    Write-Output "  modal-settings WAS found but quote style mismatch"
  }
}

# 5. Add oncontextmenu to msg elements
$c = $c.Replace(
  '<div class="msg assistant">',
  '<div class="msg assistant" oncontextmenu="showMsgContextMenu(event, this)">'
)
$c = $c.Replace(
  '<div class="msg user">',
  '<div class="msg user" oncontextmenu="showMsgContextMenu(event, this)">'
)

# 6. Update welcome message
$c = $c.Replace(
  '按 <kbd>Tab</kbd> 可以切换到其他主代理，对话上下文保持不变。',
  '按 <kbd>Tab</kbd> 切换主代理，<kbd>Ctrl+,</kbd> 打开设置，<kbd>Ctrl+N</kbd> 新建对话。'
)

Set-Content $f -Value $c -Encoding UTF8 -NoNewline
Write-Output "DONE. Length: $($c.Length)"
