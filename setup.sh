#!/bin/bash
setup_path=$(cd $(dirname $0); pwd)
share_vim_plubin_path="${setup_path}/plugin"

user_vim_plugin_path="${HOME}/.vim/plugin"
user_vim_ftplugin_path="${HOME}/.vim/ftplugin"
vim_plugin_ls=("automatic.vim"
               "automatic.v2.vim"
               "verilog_emacsauto.vim"
              )
verilog_mode_el="${setup_path}/lisp/verilog-mode.el"		  
rm -rf "${user_vim_ftplugin_path}/verilog_emacsauto.vim"		
date_str=`date  +%Y-%m%d-%H%M`
mkdir -p $user_vim_plugin_path
cd 	$user_vim_plugin_path
ln -sf  $verilog_mode_el
for plugin in ${vim_plugin_ls[*]};do
    if [ -f $plugin ]; then
	mkdir -p bak.${date_str}
	mv -f $plugin bak.${date_str}
	fi
	ln -sf $share_vim_plubin_path/$plugin
	RESVAL=$?
	if [ $RESVAL -ne 0 ]; then
    break;
    fi	
done
if [ $RESVAL -ne 0 ]; then
    echo "Error: GVIM plugin verilog-V2 setup exit with $RESVAL"
else
    echo "GVIM plugin verilog-V2 setup done!"
fi
