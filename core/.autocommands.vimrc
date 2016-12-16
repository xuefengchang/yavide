" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AutoCommands
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup yavide_environment_mgmt_group
    autocmd!
    autocmd VimEnter                *                               call Y_Env_Init()
    autocmd VimLeave                *                               call Y_Env_Deinit()
augroup END

augroup yavide_src_code_indexer_group
    autocmd!
    autocmd BufEnter                *.java                          exec 'set tags='.g:project_java_tags
    autocmd BufEnter                *.cpp,*.cc,*.c,*.h,*.hh,*.hpp   exec 'set tags='.g:project_cxx_tags
augroup END

augroup yavide_src_code_formatting_group
    autocmd!
    autocmd BufWritePost            *.cpp,*.cc,*.c,*.h,*.hh,*.hpp   call Y_SrcCodeFormatter_Run()
augroup END

augroup yavide_src_code_highlight_group
    autocmd!
    autocmd BufEnter                *.cpp,*.cc,*.c,*.h,*.hh,*.hpp   call Y_SrcCodeHighlighter_Run()
    "autocmd BufWritePost            *.cpp,*.cc,*.c,*.h,*.hh,*.hpp   call Y_SrcCodeHighlighter_Run()
    autocmd TextChangedI            *.cpp,*.cc,*.c,*.h,*.hh,*.hpp  call Y_SrcCodeHighlighter_RunConditionally()
augroup END

augroup yavide_layout_mgmt_group
    autocmd!
    autocmd FileType                qf                              wincmd J
augroup END

augroup yavide_editor_group
    autocmd!
    autocmd FileType                c,cpp,java                      autocmd BufWritePre <buffer> :call Y_Buffer_StripTrailingWhitespaces()
augroup END

