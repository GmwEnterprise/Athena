$ErrorActionPreference = "Stop"
$f = "C:\Users\90949\myprojects\Athena\design-athena\chat.html"
$c = Get-Content $f -Raw -Encoding UTF8

# 1. Update toast position (bottom: 24px -> 40px)
$c = $c.Replace(
  "            background: var(--fg); color: var(--bg);`n            padding: 12px 24px; border-radius: var(--radius-lg);`n            font-size: 14px; font-weight: 500;`n            box-shadow: var(--elev-raised);`n            opacity: 0; transition: all 0.24s var(--ease-standard);`n            pointer-events: none; z-index: 100;",
  "            background: var(--fg); color: var(--bg);`n            padding: 8px 20px; border-radius: var(--radius-md);`n            font-size: 13px; font-weight: 500;`n            opacity: 0; transition: all 0.2s var(--ease-standard);`n            pointer-events: none; z-index: 100;"
)
$c = $c.Replace(
  "          transform: translateX(-50%) translateY(20px);`n          background:",
  "          transform: translateX(-50%) translateY(16px);`n          background:"
)

# 2. Remove updateThemeIcon function and simplify toggleTheme
$oldThemeFuncs = @'
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
'@
$newThemeFunc = @'
    function toggleTheme() {
      var html = document.documentElement;
      var current = html.getAttribute('data-theme') || 'dark';
      var next = current === 'dark' ? 'light' : 'dark';
      html.setAttribute('data-theme', next);
      localStorage.setItem('athena-theme', next);
    }
'@
$c = $c.Replace($oldThemeFuncs, $newThemeFunc)

# 3. Add keyboard shortcuts in the Tab key handler (insert after the Tab handler before the closing })
$oldKeyHandlerEnd = @'
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Tab' && !e.ctrlKey && !e.metaKey && !e.shiftKey && !e.altKey) {
        const input = document.getElementById('chatInput');
        if (document.activeElement === input) {
          return;
        }
        e.preventDefault();
        const idx = state.primaryAgents.findIndex(a => a.id === state.currentAgentId);
        const nextIdx = (idx + 1) % state.primaryAgents.length;
        switchAgent(state.primaryAgents[nextIdx].id);
      }
    });
'@
$newKeyHandlerEnd = @'
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Tab' && !e.ctrlKey && !e.metaKey && !e.shiftKey && !e.altKey) {
        const input = document.getElementById('chatInput');
        if (document.activeElement === input) {
          return;
        }
        e.preventDefault();
        const idx = state.primaryAgents.findIndex(a => a.id === state.currentAgentId);
        const nextIdx = (idx + 1) % state.primaryAgents.length;
        switchAgent(state.primaryAgents[nextIdx].id);
      }
      if ((e.ctrlKey || e.metaKey) && e.key === ',') {
        e.preventDefault();
        openModal('settings');
      }
      if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
        e.preventDefault();
        newConversation();
      }
      if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        openModal('history');
      }
      if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
        e.preventDefault();
        toggleSidebar();
      }
    });
'@
$c = $c.Replace($oldKeyHandlerEnd, $newKeyHandlerEnd)

# 4. Update switchAgent to also update sbModel
$oldSwitchAgent = '      document.getElementById(''agentTriggerName'').textContent = next.name;'
$newSwitchAgent = @'
      document.getElementById('agentTriggerName').textContent = next.name;

      document.getElementById('sbModel').textContent = next.model;
'@
$c = $c.Replace($oldSwitchAgent, $newSwitchAgent)

# 5. Update renderTokenPanel to also set sbTokens
$oldTokenDisplay = '$display);`n      document.getElementById(''tdFill'').style.width'
$newTokenDisplay = '$display);`n      document.getElementById(''sbTokens'').textContent = display;`n      document.getElementById(''tdFill'').style.width'
$c = $c.Replace(
  "document.getElementById('tokenTriggerText').textContent = display;",
  "document.getElementById('tokenTriggerText').textContent = display;`n      document.getElementById('sbTokens').textContent = display;"
)

# 6. Add sidebar toggle function + sidebar resize + context menu functions before "renderAgentDropdown()"
$oldRenderAgent = "    renderAgentDropdown();"
$newFunctions = @'
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

    function contextAction(action) {
      closeAllContextMenus();
      if (action === 'copy' || action === 'copyContent') {
        if (activeContextMenu && activeContextMenu.element) {
          var text = activeContextMenu.element.textContent || '';
          navigator.clipboard.writeText(text).then(function() { showToast('已复制'); });
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
      if (action === 'rename') {
        showToast('重命名...');
      } else if (action === 'pin') {
        showToast('已置顶');
      } else if (action === 'delete') {
        if (activeContextMenu && activeContextMenu.element) {
          activeContextMenu.element.remove();
          showToast('已删除');
        }
      }
    }

    document.addEventListener('contextmenu', function(e) {
      if (!e.target.closest('.msg') && !e.target.closest('.conv-item')) {
        closeAllContextMenus();
      }
    });

    document.addEventListener('click', function() {
      closeAllContextMenus();
    });

    renderAgentDropdown();
'@
$c = $c.Replace($oldRenderAgent, $newFunctions)

# 7. Update sendMessage to add oncontextmenu to created elements
$oldSendMsg = 'userMsg.className = ''msg user'';'
$newSendMsg = 'userMsg.className = ''msg user'';`n      userMsg.setAttribute(''oncontextmenu'', ''showMsgContextMenu(event, this)'');'
$c = $c.Replace($oldSendMsg, $newSendMsg)

$oldAiMsg = 'aiMsg.className = ''msg assistant'';'
$newAiMsg = 'aiMsg.className = ''msg assistant'';`n        aiMsg.setAttribute(''oncontextmenu'', ''showMsgContextMenu(event, this)'');'
$c = $c.Replace($oldAiMsg, $newAiMsg)

# 8. Update the Escape handler to also close context menus
$oldEscape = "        document.getElementById('tokenDropdown').classList.remove('open');`n        tokenDropdownOpen = false;"
$newEscape = "        closeAllContextMenus();`n        document.getElementById('tokenDropdown').classList.remove('open');`n        tokenDropdownOpen = false;"
$c = $c.Replace($oldEscape, $newEscape)

# 9. Update global click handler
$oldGlobalClick = "        document.getElementById('tokenDropdown').classList.remove('open');`n        tokenDropdownOpen = false;`n      }`n    });"
$newGlobalClick = "        document.getElementById('tokenDropdown').classList.remove('open');`n        tokenDropdownOpen = false;`n      }`n      closeAllContextMenus();`n    });"
$c = $c.Replace($oldGlobalClick, $newGlobalClick)

Set-Content $f -Value $c -Encoding UTF8 -NoNewline
Write-Output "JS transforms complete. Length: $($c.Length)"
