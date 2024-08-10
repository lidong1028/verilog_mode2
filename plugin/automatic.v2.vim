"Vim Plugin for Verilog Code AutomacticGeneration&check
"Language: Verilog
"Maintainer:Gavin Ge<arrowroothover@hotmail.com>
"Version: 1.55
"Last Update : Wed. sept 17 2008
"For version 7.x or above

if version < 700
    finish
endif
if exists("b:v2_vlog_plugin")
    finish
endif
let b:v2_vlog_plugin =1

iabbrev <= <= #`RD

if exists("b:vlog_company")== 0
    let b:vlog_company = $USER
endif
if exists("b:vlog_max_col")== 0
    let b:vlog_max_col = 40
endif
if exists("b:vlog_arg_margin")== 0
    let b:vlog_arg_margin = "    "
endif

if exists("b:vlog_inst_margin")== 0
    let b:vlog_inst_margin = "    "
endif
if exists("b:verilog_indent_width")
    let b:vlog_ind = b:verilog_indent_width
else
    let b:vlog_ind=4
endif

"===================================================================
"       Verilog-mode
"===================================================================
if  !$DIS_GVIM_VERILOG_MODE
    source ~/.vim/plugin/verilog_emacsauto.vim
endif

amenu  &Verilog-V2.FileTemplate     :call V2_FileTemplate()                       <CR>
amenu  &Verilog-V2.-Template-       :
amenu  &Verilog-V2.Header           :call V2_AddHeader()                          <CR>
amenu  &Verilog-V2.Comment          :call V2_AddComment()                         <CR>

amenu  &Verilog-V2.-Automatic-      :
amenu  &Verilog-V2.V2:\ Add\ AutoDefine(V2AA)          :call V2_AutoDef()         <CR>
amenu  &Verilog-V2.V2:\ Del\ AutoDefine(V2DA)          :call V2_KillAutoDef()     <CR>
if !$DIS_GVIM_VERILOG_MODE
    amenu  &Verilog-V2.-Verilog-mode-          :
	amenu  &Verilog-V2.Verilog-mode:\ Add\ Auto\ (VMAA)          :call VmAdd()    <CR>
	amenu  &Verilog-V2.Verilog-mode:\ Del\ Auto\ (VMDA)          :call VmDelete() <CR>
endif

amenu  &Verilog-V2.-Code\ Block-                       :
amenu  &Verilog-V2.Always\ @(clk)\ (AL1)               :call V2_AddAlwaysClk()    <CR>
amenu  &Verilog-V2.Always\ @(*)\ (AL2)                 :call V2_AddAlwaysComb()   <CR>
amenu  &Verilog-V2.Case\ (CAS)                         :call V2_AddCase()         <CR>
command AL1 :call V2_AddAlwaysClk()
command AL2 :call V2_AddAlwaysComb()
command CAS :call V2_AddCase()
command V2AA  :call V2_AutoDef()      <CR>
command V2DA  :call V2_KillAutoDef()  <CR>
if !$DIS_GVIM_VERILOG_MODE
    command VMAA :call VmAdd()        <CR>
    command VMDA :call VmDelete()     <CR>
endif

"==============================================================
"             Add File Header
"==============================================================
function V2_AddHeader()
    call append(0,"//=========================================")
    call append(1,"//Created by    :".b:vlog_company)
    call append(2,"//Filename      :".expand("%"))
    call append(3,"//Author        :".$USER."(RDC)")
    call append(4,"//Created On    :".strftime("%Y-%m-%d %H:%M"))
    call append(5,"//Last Modified :")
    call append(6,"//Update Count  :")
    call append(7,"//Description   :")
    call append(8,"//")
    call append(9,"//")
	call append(10,"//=========================================")
    call append(11,"//")
endfunction

"==============================================================
"             Add Comment Lines
"==============================================================
function V2_AddComment()
    let curr_line = line(".")
    call append(curr_line,"//=========================================")
    call append(curr_line+1,"//    ")
	call append(curr_line+2,"//=========================================")
endfunction

"==============================================================
"             Add File Header
"==============================================================
function V2_FileTemplate()
    call append(0,"//=========================================")
    call append(1,"//Created by    :".b:vlog_company)
    call append(2,"//Filename      :".expand("%"))
    call append(3,"//Author        :".$USER."(RDC)")
    call append(4,"//Created On    :".strftime("%Y-%m-%d %H:%M"))
    call append(5,"//Last Modified :")
    call append(6,"//Update Count  :")
    call append(7,"//Description   :")
    call append(8,"//")
    call append(9,"//")
	call append(10,"//=========================================")
    call append(11,"//")
	
    call append(12,"module ".expand("%:r")." #(")
    call append(13,"    parameter  integer DW_IN  = 10,")
    call append(14,"    parameter  integer DW_OUT = 12")
    call append(15,")")
    call append(16,"(")
	call append(17,"    //=========================================")
    call append(18,"    //ports declared by Verilog-mode tool")
	call append(19,"    //=========================================")
    call append(20,"    /*autoinput(\"^clk\\|^rst\")*/")
    call append(21,"")	
	call append(22,"    /*autoinput(\"^din\\([0-1]\\)_\\(a\\|b\\)\")*/")
    call append(23,"")	
	call append(24,"    /*autooutput(\"^dout_*\")*/")
    call append(25,"")		
	call append(26,"    //=========================================")	
    call append(27,"    // ports declared by user")			
	call append(28,"    //=========================================")	
	call append(29,"    // input/output to/from internal logic block")
	
	call append(30,"    input                 din_vld,")	
	call append(31,"    output                dout_vld,")	
	call append(32,"")	
	call append(33,"    // output from inter-connection of internal instance")	
	call append(34,"    output  [11:0]        inter_out0_a,")	
	call append(35,"    output  [11:0]        inter_out0_b,")	
    call append(36,");")	
	call append(37,"//===========================")	
    call append(38,"//Local parameters")			
	call append(39,"//===========================")		
	call append(40,"//")	
	call append(41,"//===========================")		
    call append(42,"//Local wires and registers")			
	call append(43,"//===========================")		
	call append(44,"/*autologic*/")		
	call append(45,"")		
	call append(46,"/*autodefine*/")		
	call append(47,"")			
	call append(48,"//  User define")			
	call append(49,"wire    userdef0;")			
	call append(50,"wire    userdef1;")			
	call append(51,"//  End of user define")			
	call append(52,"//")	
	call append(53,"//===========================")		
	call append(54,"//Main code begins here")			
	call append(55,"//===========================")			
	call append(56,"//")			
	call append(57,"")			
	call append(58,"")			
	call append(59,"")			
	call append(60,"")			
	call append(61,"")			
	call append(62,"/*")			
	call append(63,"module0 auto_template (")			
	call append(64,"    .clk           (clk             ),")			
	call append(65,"    .rst_n         (rst_n           ),")			
	call append(66,"    .din_vld       (inter_vld@      ),")			
	call append(67,"    .din_a         (din@_a[]        ),")			
	call append(68,"    .din_b         (din@_b[]        ),")			
	call append(69,"    .dout\\(.*\\)  (inter_out@\\1[] ),")			
	call append(70,"    .debug         (inter_con       ),")			
	call append(71,");")			
	call append(72,"*/")			
	call append(73,"module0 # (")			
	call append(74,"  .DW_IN    (DW_IN ),")			
	call append(75,"  .DW_OUT   (DW_OUT),")			
	call append(76,")  inst0 (/*autoinst*/);")			
	call append(77,"")	
	call append(78,"//=========================================")	
	call append(79,"//Verilog-mode Setting:")	
	call append(80,"//Local Variables:")	
	call append(81,"//verilog-library-files: (")	
	call append(82,"//\"./test.v\"")	
	call append(83,"//\)")	
	call append(84,"//verilog-library-directories: (")	
	call append(85,"//\".\"")		
	call append(86,"//\"..\"")		
	call append(87,"//\)")		
	call append(88,"//verilog-auto-inst-param-value: t")		
	call append(89,"//End:")		
	call append(90,"//=========================================")		
	call append(91,"endmodule")		
endfunction
"==========================================================
"  Add RTL Code Template
"==========================================================
function  V2_AddAlwaysClk()
    let curr_line = line(".")
    call append(curr_line+0, "always @(posedge clk or negedge rst_n) begin")
    call append(curr_line+1, "    if(!rst_n) begin")
    call append(curr_line+2, "        ")
    call append(curr_line+3, "    end else begin")
    call append(curr_line+4, "        ")
    call append(curr_line+5, "    end")
    call append(curr_line+6, "end")
    call append(curr_line+7, "")
endfunction
function  V2_AddAlwaysComb()
    let curr_line = line(".")
    call append(curr_line+0, "always @(*) begin")
    call append(curr_line+1, "    if( ) begin")
    call append(curr_line+2, "        ")
    call append(curr_line+3, "    end else begin")
    call append(curr_line+4, "        ")
    call append(curr_line+5, "    end")
    call append(curr_line+6, "end")
    call append(curr_line+7, "")
endfunction
function  V2_AddCase()
    let curr_line = line(".")
    call append(curr_line+0  , "case(state[1:0])")
    call append(curr_line+1  , "    2'd0: begin")
    call append(curr_line+2  , "        ")
    call append(curr_line+3  , "    end")
    call append(curr_line+4  , "    2'd1: begin")
    call append(curr_line+5  , "        ")
    call append(curr_line+6  , "    end")
    call append(curr_line+7  , "    2'd2: begin")
    call append(curr_line+8  , "        ")
    call append(curr_line+9  , "    end")
    call append(curr_line+10, "    2'd3: begin")
    call append(curr_line+11, "        ")
    call append(curr_line+12, "    end")
    call append(curr_line+13, "    default: begin")
    call append(curr_line+14, "        ")
    call append(curr_line+15, "    end")
    call append(curr_line+16, "endcase")
    call append(curr_line+17, "")
endfunction
"==========================================================
"      Update Current buffer
"==========================================================
function V2_UpdateBuf(new_lines)
    if len(a:new_lines) < line("$")
        for line_index in range(1,line("$"),1)
            if line_index > len(a:new_lines)
               call setline(line_index, "")
               $delete
            else
                call setline(line_index, a:new_lines[line_index-1])
            endif
        endfor
    else 
        for line_index in range(1, len(a:new_lines), 1)
            call setline(line_index, a:new_lines[line_index-1])
        endfor
    endif
endfunction
"==========================================================
"      Remove Comments and Functions from Current Buffer
"==========================================================
function V2_Filter(lines)
    let aft_filter = []
    let line_index = 1
    "echo "a:lines = "
    "echo a:lines
    while line_index <= len(a:lines)
        let line = a:lines[line_index-1]
        if (line =~ '^.*\(notouch\|NOTOUCH\).*$') || (line =~ '//  Begining of automatic \(inputs\|outputs\|wires\)') || (line =~ '//  End of automatic')
            let line_index = line_index + 1
            call add(aft_filter, line)
        else 
            let line = substitute(line, '//.*$', "", "")
            if line =~ '^.*/\*' && line !~ '\*/.*$'
                let line = substitute(line, '/\*.*$', "", "")
                call add(aft_filter,line)
                let line_index = line_index + 1
                let line = a:lines[line_index - 1]
                while line !~ '\*/.*$'
                    let line_index = line_index + 1
                    let line = a:lines[line_index - 1]                 
                 endwhile
            elseif line =~ '^\s*\<function>\>'
                 let line_index = line_index + 1
                 let line = a:lines[line_index - 1]         
                 while line !~ '^\s*\<endfunction>\>'
                    let line_index = line_index + 1
                    let line = a:lines[line_index - 1]                 
                 endwhile          
            elseif line =~ '^\s*\<endmodule>\>'
                call add(aft_filter, line)
                break
            else
              if line !~ '^.*/\*'
                   let line = substitute(line, '^.*\*/', "", "")
              endif
              let line = substitute(line, '^\s*\<endfunction\>', "", "")
              let line_index = line_index + 1
              if line != ""
                  call add(aft_filter, line)
              endif
           endif
       endif
    endwhile
    return aft_filter
endfunction





"==========================================================
"      Automatic Argument Generation
"==========================================================
function V2_KillAutoArg()
    let aft_kill = []
    let line_index = 1
    let line = ""
    while line_index <= line("$")
        let line = getline(line_index)
        if line =~ '^\s*\<module\>' && line =~ '\<\(autoarg\|AUTOARG\)\>\*/\s*$'
            call add(aft_kill, line.");")
            let line_index = line_index + 1
            while line !~ ');\s*$' && line_index < line("$") && line !~ '^\s*\<endmodule\>'
                let line_index = line_index + 1
                let line = getline(line_index)
            endwhile
            let line_index = line_index + 1
        elseif line =~ '^\s*\<endmodule\>'
            call add(aft_kill, line)
            break
        else
            call add(aft_kill, line)
            let line_index = line_index + 1
        endif
    endwhile
    call V2_UpdateBuf(aft_kill)
endfunction

"==========================================================
"      Automatic Instance Generation
"==========================================================
function V2_CalMargin(max_len, cur_len)
    let margin = ""
    for i in range(1, a:max_len-a:cur_len+1, 1)
        let margin = margin." "
    endfor
    return margin
endfunction

"==========================================================
"      Automatic Signal Definition Generation
"==========================================================
function V2_UserDef(lines)
    let user_def = {}
    let automatic_flag = 0
    for line in a:lines
        if line =~ '//  Beginning of automatic wires'
            let automatic_flag = 1
        elseif (automatic_flag == 1) && (line =~ '//  End of automatics')
            let automatic_flag = 0
        elseif (automatic_flag == 0) &&  (line !~ '^.*;\s*\/\/\s*\(notouch\|NOTOUCH\).*$')
            if line =~ '^\s*\<output\>\s*\<reg\>' || line =~ '^\s*\<output\>\s*\<signed\>'
                 let line = substitute(line, '\s*[;,)].*$', "", "")
                 let signal_name = matchstr(line, '\(\]\|\s\)\w\+$')
                 let signal_name = substitute(signal_name, '^\(\]\|\s\)', "", "")
                 "echo "UserDef signa_name ".signal_name
                 call extend(user_def, {signal_name : ''})
             elseif line =~ '^\s*\(\<wire\>\|\<reg\>\|\<genvar\>\|\<integer\>\|\<logic\>\)'
                 let signal_name = substitute(line, '\s*\[[^\[\]]*\]\s*;', ";", "")
                 let signal_name = substitute(signal_name, '\s*;.*$', "", "")
                 let signal_name = matchstr(signal_name, '\(\]\|\s\)\w\+$')
                 let signal_name = substitute(signal_name, '^\(\]\|\s\)', "", "")
                 "echo "UserDef signa_name ".signal_name
                 call extend(user_def, {signal_name : line})
              endif
          endif
    endfor
    return user_def
endfunction

function V2_GetNoTouch(lines)
    let NoTouch = {}
    for line in a:lines
        if line =~ '^.*\(notouch\|NOTOUCH\).*$'
            let line = substitute(line, '\s*;.*$', "", "")
            let signal_name = substitute(line, '\[\s*.*\s*\]', "", "")
            let signal_name = substitute(signal_name, '^\s*\w*\s*', "", "")
            call extend(NoTouch, {signal_name : line})
         endif
     endfor
     return  NoTouch
endfunction

function V2_PushSignal(signals, signal_name, signal_msb, signal_width, max_len, user_def, NoTouch)
    if has_key(a:user_def, a:signal_name) == 1 || has_key(a:NoTouch, a:signal_name) == 1
        return a:max_len
    " Signal width comes from the right part of the assignment
    elseif a:signal_msb == ""
         if has_key(a:signals, a:signal_name) == 1
             if a:signals[a:signal_name] =~ '\d\+'
                 if str2nr(a:signals[a:signal_name], 10) < (a:signal_width-1)
                     call extend(a:signals, {a:signal_name : a:signal_width-1}, "force")
                 endif
              endif
          else
              call extend(a:signals, {a:signal_name : a:signal_width-1}, "force")
           endif
       " Signal width comes from the left part of the assignment
       " if MSB is a parameter then update value with it
       elseif a:signal_msb !~ '^\d\+$'
           call extend(a:signals, {a:signal_name : a:signal_msb}, "force")
       elseif has_key(a:signals, a:signal_name) != 1
           call extend(a:signals, {a:signal_name : a:signal_msb}, "force")
        " if the old value is a parameter do not update
        elseif a:signals[a:signal_name] !~ '^[a-zA-Z].*'
            if a:signal_msb == 0
               call extend(a:signals, {a:signal_name : 0}, "force")
            elseif str2nr(a:signals[a:signal_name], 10) < a:signal_msb 
                call extend(a:signals, {a:signal_name : a:signal_msb}, "force")
            endif
          endif
          if a:max_len < (len(a:signal_msb) + 4)
              return len(a:signal_msb) + 4
          elseif a:max_len <  (len(a:signal_width) + 4)
              return len(a:signal_width) + 4
           else
              return a:max_len
           endif
endfunction

function V2_KillAutoDef()
    let aft_kill = []
    let line_index = 1
    while line_index <= line("$")
        let line = getline(line_index)
        if line == "//  Define flip-flop registers here"
            let line_index = line_index + 1
            let line = getline(line_index)
            while line != "//  End of automatic define"
                let line_index = line_index + 1
                let line = getline(line_index)
             endwhile
             let line_index = line_index + 1     
         else
             call add(aft_kill, line)       
             let line_index = line_index + 1     
         endif
     endwhile
     if len(aft_kill) < line("$")
         for line_index in range(1, line("$"))
             if line_index > len(aft_kill)
                 call setline(line_index, "")
             else 
                 call setline(line_index, aft_kill[line_index-1])
             endif
         endfor
     else
         for line_index in range(1, len(aft_kill), 1)
             call setline(line_index, aft_kill[line_index-1])
          endfor
     endif
     call V2_KillAutoArg()
     w!
endfunction

function V2_AutoDef()
    let ff_reg = {}
    let comb_reg = {}
    let inst_wire = {}
    let wire = {}
    let aft_def = []
    let max_len = 0
    let line_index = 1
    let signal_name = ""
    let signal_msb = ""
    let signal_width = ""
    let automatic_flag = 0
    call V2_RebuildOutputPort()

    call V2_KillAutoDef()

    
    let lines = V2_Filter(getline(1, line("$")))
    let outreg_list = []
    let outwire_list = []
    call V2_GetOutRegPort(lines, outreg_list)
    call V2_GetOutWirePort(lines, outwire_list)
    " Find Signals Declared by User
    let user_def = V2_UserDef(lines)
    " Find Signals commentted by notouch (not in function)
    let NoTouch = V2_GetNoTouch(lines)
    " Get Flip-flop Reg Signals
    while line_index <= len(lines)
        let line = lines[line_index - 1]
        if line =~ '^\s*\<always\>\s*@\s*(\s*\(posedge\|negedge\)\>'
            let line_index = line_index + 1
            let line = lines[line_index-1]
            while line !~ '^\s*\<always\>' && line !~ '^\s*\<assign\>' && line !~ '^\<end\>'
                     \&& line !~ '^\s*\<endmodule\>' && line !~ '^.*\w*\.\w.*=.*'
                " Remove if(...)
                let line = substitute(line, '\<if\>\s*(.*)', " ", "")
                " Remove  ...?
                let  line = substitute(line, '\s\+\w\+\s*?', " ", "g")
                " Remove  (...)?
                let  line = substitute(line, '([^()]*)\s*?', " ", "g")
                " Remove  )
                let  line = substitute(line, ')', "", "g")
                if line =~ '.*<=.*'
                    let line = matchstr(line, '\s\+\w\+\(\[.*\]\)*\s*<=.*\(;\|:\)')
                    let line = substitute(line, '^\s*', "", "")
                    let line = substitute(line, '\(;\|:\)$', "", "")
                    let signal_name = substitute(line, '\s*<=.*', "", "")
                    " Match signal[M:N]
                    if signal_name =~ ':.*]$'
                        let signal_msb = substitute(signal_name, '\s*:.*$', "", "")
                        let signal_msb = substitute(signal_msb, '^.*[\s*', "", "")
                        let signal_name = substitute(signal_name, '[.*$', "", "")
                        let max_len = V2_PushSignal(ff_reg, signal_name, signal_msb, "", max_len, user_def, NoTouch)
                    "Match signal <= M'hN or #1 M'dN or # `RD M'bN
                    elseif line =~ "^\\s*\\w\\+\\s*<=\\s*\\(#\\s*`*\\w*\\)*\\s\\+\\d\\+'\\(b\\|h\\|d\\).*"
                        let signal_width = substitute(line,"^\\s*\\w\\+\\s*<=\\s*\\(#\\s*`*\\w*\\)*\\s\\+", "", "")
                        let signal_width = substitute(signal_width,"'\\(b\\|h\\|d\\).*", "", "")
                        " delete [N]
                        let signal_name = substitute(signal_name,'[.*$', "", "")
                        let max_len = V2_PushSignal(ff_reg, signal_name, "", signal_width, max_len, user_def, NoTouch)
                    " Match signal[N]
                    elseif  signal_name =~ '\[.\+\]$'
                        let signal_msb = substitute(signal_name,']$', "", "")
                        let signal_msb = substitute(signal_msb,'^.*[', "", "")
                        let signal_name = substitute(signal_name,'[.*$', "", "")
                        let max_len = V2_PushSignal(ff_reg, signal_name, signal_msb, "", max_len, user_def, NoTouch)        
                     else
                        let max_len = V2_PushSignal(ff_reg, signal_name, "", 1, max_len, user_def, NoTouch)        
                     endif
                 endif
                 let line_index = line_index + 1
                 let line  = lines[line_index-1]
             endwhile
             let line_index = line_index - 1
     " Get Combination Reg Signals
     elseif line =~ '^\s*\<always\>'
         let line_index = line_index + 1
         let line  = lines[line_index-1]
         while line !~ '^\s*\<always\>' && line !~ '^\s*\<assign\>' && line !~ '^\<end\>'
                       \&& line !~ '^\s*\<endmodule\>' && line !~ '^.*\w*\.\w.*=.*'
            " Remove if(...)
            let line = substitute(line, '\<if\>\s*(.*)', " ", "")
            " Remove  ...?
            let  line = substitute(line, '\s\+\w\+\s*?', " ", "g")
            " Remove  (...)?
            let  line = substitute(line, '([^()]*)\s*?', " ", "g")
            " Remove  )
            let  line = substitute(line, ')', "", "g")
            if line =~ '.*=.*'
                let line = matchstr(line, '\s\+\w\+\(\[.*\]\)*\s*=.*\(;\|:\)')
                let line = substitute(line, '^\s*', "", "")
                let line = substitute(line, '\(;\|:\)$', "", "")
                let signal_name = substitute(line, '\s*=.*', "", "")
                " Match signal[M:N]
                if signal_name =~ ':.*]$'
                    let signal_msb = substitute(signal_name, '\s*:.*$', "", "")
                    let signal_msb = substitute(signal_msb, '^.*[\s*', "", "")
                    let signal_name = substitute(signal_name, '[.*$', "", "")
                    let max_len = V2_PushSignal(comb_reg, signal_name, signal_msb, "", max_len, user_def, NoTouch)
                "Match signal = M'hN ;
                elseif line =~ "^\\s*\\w\\+\\s*=\\s*\\d\\+'\\\(b\\|h\\|d\\).*"
                    let signal_width = substitute(line,'^\s*\w\+\s*=\s*', "", "")
                    let signal_width = substitute(signal_width,"'\\(b\\|h\\|d\\).*", "", "")
                    let signal_name = substitute(signal_name,'[.*$', "", "")
                    let max_len = V2_PushSignal(comb_reg, signal_name, "", signal_width, max_len, user_def, NoTouch)
                " Match signal[N]
                elseif  signal_name =~ '\[.\+\]$'
                    let signal_msb = substitute(signal_name,']$', "", "")
                    let signal_msb = substitute(signal_msb,'^.*[', "", "")
                    let signal_name = substitute(signal_name,'[.*$', "", "")
                    let max_len = V2_PushSignal(comb_reg, signal_name, signal_msb, "", max_len, user_def, NoTouch)        
                 else
                    let max_len = V2_PushSignal(comb_reg, signal_name, "", 1, max_len, user_def, NoTouch)        
                 endif
             endif
             let line_index = line_index + 1
             let line  = lines[line_index-1]
         endwhile
         let line_index = line_index - 1
     " Get Wires
     elseif line =~ '^\s*\<assign\>' && line !~ '^\s*\<assign\>\s*\w*\(\|\[.*\]\)\.\w.*=.*'
                let line = substitute(line, '\s\+\w\+\s*?', " ", "g")
                let line = substitute(line, '(.*)\s*?', " ", "g")
                let signal_name = substitute(line, '^\s*\<assign\>\s*', "", "")
                let signal_name = substitute(signal_name, '\s*=.*', "", "g")
                " Match signal[M:N]
                if signal_name =~ ':.*]\s*$'
                    let signal_msb = substitute(signal_name, '\s*:.*$', "", "")
                    let signal_msb = substitute(signal_msb, '^.*[\s*', "", "")
                    let signal_name = substitute(signal_name, '[.*$', "", "")
                    if has_key(inst_wire,signal_name)
                        let max_len = V2_PushSignal(inst_wire, signal_name, signal_msb, "", max_len, user_def, NoTouch)
                    else
                        let max_len = V2_PushSignal(wire, signal_name, signal_msb, "", max_len, user_def, NoTouch)
                    endif
                "Match signal = M'hN 
                elseif line =~ "^\\s*\\<assign\\>\\s*\\w\\+\\s*=\\s*\\d\\+'\\(b\\|h\\|d\\).*"
                    let signal_width = substitute(line,'^\s*\<assign\>\s\+\w\+\s*=\s*', "", "")
                    let signal_width = substitute(signal_width,"'\\(b\\|h\\|d\\).*", "", "")
                    let signal_name = substitute(signal_name,'[.*$', "", "")
                    let max_len = V2_PushSignal(wire, signal_name, "", signal_width, max_len, user_def, NoTouch)
                elseif  signal_name =~ '\[.\+\]$'
                    let signal_msb = substitute(signal_name,']$', "", "")
                    let signal_msb = substitute(signal_msb,'^.*[', "", "")
                    let signal_name = substitute(signal_name,'[.*$', "", "")
                    if has_key(inst_wire,signal_name)
                        let max_len = V2_PushSignal(inst_wire, signal_name, signal_msb, "", max_len, user_def, NoTouch)
                    else
                        let max_len = V2_PushSignal(wire, signal_name, signal_msb, "", max_len, user_def, NoTouch)
                    endif
                 else
                    let max_len = V2_PushSignal(wire, signal_name, "", 1, max_len, user_def, NoTouch)        
                 endif
                 let line_index = line_index + 1
         elseif line =~ '^\s*\<endmodule\>'
             break
         else
             let line_index = line_index + 1
             let line = lines[line_index - 1]
         endif
     endwhile
     for line in getline(1, line("$"))
         if line =~ '^\s*/\*\<\(autodefine\|AUTODEFINE\)\>\*/'
             call add(aft_def, line)
             call add(aft_def, "//  Define flip-flop registers here")
             for regs in sort(keys(ff_reg))
                 if count(outreg_list,regs)==0
                     let margin = V2_CalMargin(max_len, len(ff_reg[regs]))
                     if ff_reg[regs] == "0"
                         call add(aft_def, "reg        ".margin.regs.";    //")
                     else
                         call add(aft_def, "reg   [".ff_reg[regs].":0]".margin.regs.";    //")
                     endif
                 endif
             endfor
             call add(aft_def, "//  Define combination registers here")
             for regs in sort(keys(comb_reg))
                 if count(outreg_list,regs)==0 && count(keys(ff_reg),regs)==0 && regs !~ '.*#.*'
                     let margin = V2_CalMargin(max_len, len(comb_reg[regs]))
                     if comb_reg[regs] == "0"
                         call add(aft_def, "reg        ".margin.regs.";    //")
                     else
                         call add(aft_def, "reg   [".comb_reg[regs].":0]".margin.regs.";    //")
                     endif
                 endif
             endfor
             call add(aft_def, "//  Define wires here")            
             for wires in sort(keys(wire))
                 if count(outwire_list,wires)==0 && count(outreg_list,wires)==0 && wires !~ '.*#.*'
                     let margin = V2_CalMargin(max_len, len(wire[wires]))
                     if wire[wires] == "0"
                         call add(aft_def, "wire       ".margin.wires.";    //")
                     else
                         call add(aft_def, "wire  [".wire[wires].":0]".margin.wires.";    //")
                     endif
                 endif
             endfor
             call add(aft_def, "//  End of automatic define")
             call add(aft_def, "//  User define")
             if user_def != {}
                 for defined in sort(keys(user_def))
                     if count(outreg_list,defined)==0 && count(outwire_list,defined)==0
                         if user_def[defined] != ""
                             call add(aft_def, user_def[defined])
                         endif
                     endif
                  endfor
              endif
              call add(aft_def, "//  End of user define")
          elseif line =~ '//  Beginning of automatic wires'
              let automatic_flag = 1
              call add(aft_def, line)
           elseif  (automatic_flag == 1) && (line =~ "//  End of automatics")
              let automatic_flag = 0
              call add(aft_def, line)     
           elseif automatic_flag == 1
              call add(aft_def, line)     
           elseif line =~ '^.*\(notouch\|NOTOUCH\).*$'
               call add(aft_def, line)     
           elseif (line !~ '^\s*\<\(wire\|reg\|genvar\|integer\|\<logic\>\)\>')  && (line !~  "//  User define") && (line !~ "//  End of user define")
               call add(aft_def, line)     
            endif
        endfor
        call V2_UpdateBuf(aft_def)
        call V2_KillAutoArg()
        w!
endfunction

function V2_GetOutRegPort(lines,io_list)
    for line in a:lines
        if line =~ '^\s*output\s\+\(logic\|reg\)\s\+\w\+'
            let port_name = substitute(line, '\s*output\s\+\(logic\|reg\)\s\+', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        elseif line =~ '^\s*output\s\+\(logic\|reg\)\s*\['
            let port_name = substitute(line, '\s*output\s\+\(logic\|reg\)\s*', "", "")
            let port_name = substitute(port_name, '\(\[.\{-}\]\)', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        elseif line =~ '^\s*inout\s\+\(logic\|reg\)\s\+\w\+'
            let port_name = substitute(line, '\s*inout\s\+\(logic\|reg\)\s\+', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        elseif line =~ '^\s*inout\s\+\(logic\|reg\)\s*\['
            let port_name = substitute(line, '\s*inout\s\+\(logic\|reg\)\s*', "", "")
            let port_name = substitute(port_name, '\(\[.\{-}\]\)', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        endif
    endfor
endfunction

function V2_GetOutWirePort(lines,io_list)
    for line in a:lines
        if line =~ '^\s*output\s*\(wire\)*\s*\['
            let port_name = substitute(line, '\s*output\s*\(wire\)*', "", "")
            let port_name = substitute(port_name, '\(\[.\{-}\]\)', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        elseif line =~ '^\s*output\s\+\(wire\)*\s*'
            \&& line !~ '^\s*output\s\+\(logic\|reg\)\s\+'
            \&& line !~ '^\s*output\s\+\(logic\|reg\)\s*\['
            let port_name = substitute(line, '\s*output\s\+\(wire\)*', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        elseif line =~ '^\s*inout\s*\(wire\)*\s*\['
            let port_name = substitute(line, '\s*inout\s*\(wire\)*', "", "")
            let port_name = substitute(port_name, '\(\[.\{-}\]\)', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        elseif line =~ '^\s*inout\s\+\(wire\)*\s*' && line !~ '^\s*inout\s\+\(logic\|reg\)\s\+' && line !~ '^\s*inout\s\+\\(logic\|reg\)\s*\['
            let port_name = substitute(line, '\s*inout\s\+\(wire\)*', "", "")
            let port_name = matchstr(port_name, '\w\+')
            call add(a:io_list,port_name)
        endif
endfor
endfunction
function V2_FindRegList(reg_list)
    let line_index = 1
    let signal_name = ""
    let lines = Filter(getline(1,line("$")))
    while line_index <= len(lines)
        let line = lines[line_index - 1]
        if line =~ '^\s*\<always\>'
            let line_index = line_index + 1
            let line = lines[line_index - 1]
            while line !~ '^\s*\<always\>' && line !~ '^\s*\<assign\>' && line !~ '^\end\>'
                        \&& line !~ '^\s*\<endmodule\>' && line !~ '^.*\w*\.\w.*=.*'
                " Remove if(...)
                let line = substitute(line, '\<if\>\s*(.*)', " ", "")
                " Remove  ...?
                let  line = substitute(line, '\s\+\w\+\s*?', " ", "g")
                " Remove  (...)?
                let  line = substitute(line, '([^()]*)\s*?', " ", "g")
                " Remove  )
                let  line = substitute(line, ')', "", "g")
                if line =~ '.*<=.*'
                    let line = matchstr(line, '\s\+\w\+\(\[.*\]\)*\s*<=.*\(;\|:\)')
                    let line = substitute(line, '^\s*', "", "")
                    let line = substitute(line, '\(;\|:\)$', "", "")
                    let signal_name = substitute(line, '\s*<=.*', "", "")
                    " Match signal[M:N]
                    if signal_name =~ ':.*]$'
                        let signal_name = substitute(signal_name, '[.*$', "", "")
                        if count(a:reg_list, signal_name)==0
                            call add(a:reg_list, signal_name)
                        endif
                    "Match signal <= M'hN or #1 M'dN or # `RD M'bN
                    elseif line =~ "^\\s*\\w\\+\\s*<=\\s*\\(#\\s*`*\\w*\\)*\\s\\+\\d\\+'\\(b\\|h\\|d\\).*"
                        let signal_name = substitute(signal_name,'[.*$', "", "")
                        if count(a:reg_list, signal_name)==0
                            call add(a:reg_list, signal_name)
                        endif
                    " Match signal[N]
                    elseif  signal_name =~ '\[.\+\]$'
                        let signal_name = substitute(signal_name,'[.*$', "", "")
                        if count(a:reg_list, signal_name)==0
                            call add(a:reg_list, signal_name)
                        endif     
                     else
                        if count(a:reg_list, signal_name)==0
                            call add(a:reg_list, signal_name)
                        endif       
                     endif
                 endif
                 let line_index = line_index + 1
                 let line  = lines[line_index-1]
             endwhile
             let line_index = line_index - 1
         elseif line =~ '\s*\(\<reg\>\|\<logic\>\)'
             let signal_name = substitute(line, '^\s*\w*\s*\(\<reg\>\|\<logic\>\)', "", "")
             let signal_name = substitute(signal_name, '^\s*', "", "")
             let signal_name = matchstr(signal_name, '^\w*')
             if count(a:reg_list, signal_name)==0
                 call add(a:reg_list, signal_name)
             endif                            
             let line_index = line_index + 1
        elseif line =~ '^\s*\<endmodule\>'
            break
        else
            let line_index = line_index + 1
            let line = lines[line_index - 1]
        endif
    endwhile
endfunction
function V2_RebuildOutputPort()
    let reg_list = []
    call V2_FindRegList(reg_list)
    let line_index = 1
    while line_index <= line("$")
    let line = getline(line_index)
    if line =~ '^\s*output\s*\['
        let port_name = substitute(line, '\s*output\s*', "", "")
        let port_name = substitute(port_name, '\(\[.\{-}\]\)', "", "")
        let port_name = matchstr(port_name, '\w\+')
        let new_name = substitute(line, 'output', "output logic", "")
        if count(reg_list,port_name)==1
            call setline(line_index, new_name)
        endif
    elseif line =~ '^\s*output\s*' && line !~ '^\s*output\s\+\(logic\|reg\)\s\+' && line !~ '^\s*output\s\+\(logic\|reg\)\s*\['
            let port_name = substitute(line, '\s*output\s*', "", "")
            let port_name = matchstr(port_name, '\w\+')
            let new_name = substitute(line, 'output', "output logic", "")
            if count(reg_list,port_name)==1
                call setline(line_index, new_name)
            endif
        endif
        let line_index = line_index + 1
    endwhile
endfunction

function V2_Debug()
    let lines = V2_Filter(getline(1, line("$")))
    let NoTouch = V2_GetNoTouch(lines)
    echo NoTouch
    let curr_col = col(".")
    echo curr_col
    let str = string(curr_col\["ab"\])
    echo str
endfunctio
