" Vim filetype plugin for using emacs verilog-mode
" Last Change: 2007 August 29
" Maintainer:  Seong Kang <seongk@wwcoms.com>
" License:     This file is placed in the public domain.
 
" comment out these two lines
" if you don't want folding or if you prefer other folding methods
"setlocal foldmethod=expr
"setlocal foldexpr=VerilogEmacsAutoFoldLevel(v:lnum)
 
if exists("loaded_verilog_emacsauto")
   finish
endif
let loaded_verilog_emacsauto = 1
 
function VmAdd()
    w!
    set ma
    set ar
    let s:shell= &shell
    let &shell= "/bin/tcsh -f"
    echo "aa"
    !emacs --batch -l ~/.vim/plugin/verilog-mode.el % -f verilog-batch-auto
    echo "bb"
    let &shell=s:shell
endfunction
 
function VmDelete()
    w!
    set ma
    set ar
    let s:shell= &shell
    let &shell= "/bin/tcsh -f"
    !emacs -batch -l ~/.vim/plugin/verilog-mode.el % -f verilog-batch-delete-auto
    let &shell=s:shell
endfunction
