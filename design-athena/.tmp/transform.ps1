$f = "C:\Users\90949\myprojects\Athena\design-athena\chat.html"
$c = Get-Content $f -Raw -Encoding UTF8

# 1. body font-size: 15px -> 14px
$c = $c.Replace("font-size: 15px;", "font-size: 14px;")

# 2. Remove theme-toggle CSS block
$oldTheme = @"
    .theme-toggle {
      width: 32px; height: 32px;
      border: none; background: var(--surface-warm);
      border-radius: 50%; color: var(--muted);
      display: grid; place-items: center;
      cursor: pointer;
      transition: var(--motion-fast) var(--ease-standard);
    }
    .theme-toggle:hover { background: var(--border-soft); color: var(--fg); }
"@
$c = $c.Replace($oldTheme, "")

# 3. Remove topbar CSS and replace with titlebar CSS
$oldTopbarCSS = @'
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
'@

$newTitlebarCSS = @'
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
'@
$c = $c.Replace($oldTopbarCSS, $newTitlebarCSS)

# 4. Remove @media (max-width: 768px) block
$oldMedia = @'
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
'@
$c = $c.Replace($oldMedia, "")

# 5. Fix agent-trigger styling (simpler, smaller)
$oldAgentTrigger = @'
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
'@

$newAgentTrigger = @'
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
$c = $c.Replace($oldAgentTrigger, $newAgentTrigger)

# 6. Simplify sidebar-head .btn-new (remove uppercase + letter-spacing)
$oldBtnNew = @'
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
'@
$newBtnNew = @'
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
'@
$c = $c.Replace($oldBtnNew, $newBtnNew)

# 7. Add sidebar wrapper, collapse, resize after .sidebar CSS block
$oldSidebarBlock = @'
    .sidebar {
      width: var(--sidebar-w);
      background: var(--surface);
      border-right: 1px solid var(--border-soft);
      display: flex;
      flex-direction: column;
      flex-shrink: 0;
    }
'@
$newSidebarBlock = @'
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
'@
$c = $c.Replace($oldSidebarBlock, $newSidebarBlock)

# 8. Add activitybar CSS after sidebar styles
$sidebarHeadEnd = ".sidebar-head {"
$activitybarCSS = @'

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
'@
# Insert activitybar before sidebar-head
$c = $c.Replace($sidebarHeadEnd, $activitybarCSS + "`n    .sidebar-head {")

# 9. Change input-area (remove shadow, remove margin, add border-top)
$oldInputArea = @'
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
'@
$newInputArea = @'
    .input-area {
      padding: 8px 12px 10px;
      border-top: 1px solid var(--border-soft);
      flex-shrink: 0;
      position: relative;
    }
'@
$c = $c.Replace($oldInputArea, $newInputArea)

# 10. Change .send-btn border-radius from 50% to var(--radius-md)
$c = $c.Replace(".send-btn {`n      width: 38px; height: 38px;`n      border: none;`n      background: var(--accent);`n      color: var(--accent-on);`n      border-radius: 50%;", ".send-btn {`n      width: 34px; height: 34px;`n      border: none;`n      background: var(--accent);`n      color: var(--accent-on);`n      border-radius: var(--radius-md);")

# 11. Change scrollbar
$oldScroll = @'
    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
    ::-webkit-scrollbar-thumb:hover { background: var(--muted); }
'@
$newScroll = @'
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.12); border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.2); }
    [data-theme="light"] ::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.12); }
    [data-theme="light"] ::-webkit-scrollbar-thumb:hover { background: rgba(0,0,0,0.2); }
'@
$c = $c.Replace($oldScroll, $newScroll)

# 12. Add context menu, statusbar CSS before .field-group
$fieldGroupStart = "    .field-group {"
$extraCSS = @'

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
'@
$c = $c.Replace($fieldGroupStart, $extraCSS + "`n    .field-group {")

# 13. Add light theme overrides for statusbar and activitybar
$lightSettingsEnd = "[data-theme=""light""] .settings-modal-content .setting-card { box-shadow: rgba(0,0,0,0.04) 0px 2px 8px; }"
$lightOverrideAdd = "[data-theme=""light""] .statusbar { border-top-color: rgba(0,0,0,0.08); }`n    [data-theme=""light""] .activitybar { border-right-color: rgba(0,0,0,0.08); }"
$c = $c.Replace($lightSettingsEnd, $lightSettingsEnd + "`n    " + $lightOverrideAdd)

# Write back
Set-Content $f -Value $c -Encoding UTF8 -NoNewline
Write-Output "CSS transforms complete. New length: $($c.Length)"
