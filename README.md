## Location

```
~/.config/nvim
```

## Testing

```
Space t, which equates to :RustLsp testables
```

## Debugging

Rustacean.nvim uses nvim-dap for debugging. The standard DAP commands work

```
Space db, which equates to :lua require('dap').toggle_breakpoint()
Space dc, which equates to :lua require('dap').continue() ## this will actually run the debugger and ask you to select a target
Space dt, which equats to terminating the debugging session.
```

## Gotchas

### Tree Sitter CLI had to be installed with cargo

cargo install --locked tree-sitter-cli
