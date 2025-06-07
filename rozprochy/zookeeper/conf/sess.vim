let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <SNR>155_AutoPairsReturn =AutoPairsReturn()
inoremap <silent> <Plug>(bullets-promote) :BulletPromote
inoremap <silent> <Plug>(bullets-demote) :BulletDemote
imap <silent> <C-G>% <Plug>(matchup-c_g%)
inoremap <silent> <Plug>(matchup-c_g%) :call matchup#motion#insert_mode()
inoremap <Plug>Nuuid =NuuidNewUuid()
imap <C-G>S <Plug>ISurround
imap <C-G>s <Plug>Isurround
imap <C-S> <Plug>Isurround
cnoremap <C-X><C-E> 
cnoremap <expr> <C-D> getcmdpos() <= strlen(getcmdline()) ? "\<Del>" : ""
cnoremap <C-E> <End>
cnoremap <C-A> <Home>
cnoremap <C-F>  <BS><Right>
cnoremap <C-B>  <BS><Left>
inoremap <silent> <Plug>(fzf-maps-i) :call fzf#vim#maps('i', 0)
inoremap <expr> <Plug>(fzf-complete-buffer-line) fzf#vim#complete#buffer_line()
inoremap <expr> <Plug>(fzf-complete-line) fzf#vim#complete#line()
inoremap <expr> <Plug>(fzf-complete-file-ag) fzf#vim#complete#path('ag -l -g ""')
inoremap <expr> <Plug>(fzf-complete-file) fzf#vim#complete#path("find . -path '*/\.*' -prune -o -type f -print -o -type l -print | sed 's:^..::'")
inoremap <expr> <Plug>(fzf-complete-path) fzf#vim#complete#path("find . -path '*/\.*' -prune -o -print | sed '1d;s:^..::'")
inoremap <expr> <Plug>(fzf-complete-word) fzf#vim#complete#word()
inoremap <expr> <C-H> pumvisible() ? '' : ''
inoremap <expr> <C-A> pumvisible() ? '' : ''
imap <C-X>s 
imap <C-X>h 
imap <C-X>a 
imap <C-X>g 
inoremap <C-X><C-S> <Plug>(UnicodeFuzzy)
inoremap <C-X><C-H> <Plug>(HTMLEntityComplete)
inoremap <C-X><C-A> <Plug>(UnicodeComplete)
inoremap <C-X><C-G> <Plug>(DigraphComplete)
imap <C-X>m 
inoremap <expr> <C-X><C-M> '=TmuxComplete()'
cnoremap <expr> <C-O> p "@+"
cnoremap <expr> <C-O> g "@*"
cnoremap <expr> <C-O> y "@\""
cnoremap <expr> <C-O> f "<cfile>"
cnoremap <expr> <C-O> e "<cexpr>"
cnoremap <expr> <C-O> c "<cWORD>"
cnoremap <expr> <C-O> w "<cword>"
cnoremap <expr> <C-O>p "=getreg('+')"
cnoremap <expr> <C-O>g "=getreg('*')"
cnoremap <expr> <C-O>y "=getreg('\"')"
cnoremap <expr> <C-O>f "=expand('<cfile>')"
cnoremap <expr> <C-O>e "=expand('<cexpr>')"
cnoremap <expr> <C-O>w "=expand('<cWORD>')"
cnoremap <expr> <C-O>u "=expand('<cword>')"
cnoremap <expr> <C-O>c "="
cnoremap <C-O>; \%V
cnoremap <C-O>? \V
cnoremap <C-O>/ \v
inoremap <C-K> <Nop>
inoremap <C-X>c 
inoremap <C-X>j 
inoremap <C-X>v 
inoremap <C-X>u 
inoremap <C-X>t 
inoremap <C-X>o 
inoremap <C-X>l 
inoremap <C-X>k 
inoremap <C-X>i 	
inoremap <C-X>f 
inoremap <C-X>d 
inoremap <C-Z> 
inoremap <expr> <C-U> pumvisible() ? '' : ''
inoremap <expr> <C-D> pumvisible() ? '' : ''
inoremap <expr> <C-@> pumvisible() ?'' : (&omnifunc == '') ? '' : ''
inoremap <expr> <Nul> pumvisible() ?'' : (&omnifunc == '') ? '' : ''
inoremap <C-Space> <Nul>
inoremap <expr> <S-Tab> pumvisible() ? "" : "<S-Tab>"
xmap  <Plug>SpeedDatingUp
nmap  <Plug>SpeedDatingUp
map  
nnoremap <silent> 	w :We
nnoremap <expr> 	F ':-'.v:count1.'tabfind '
nnoremap <expr> 	f ':'.v:count1.'tabfind '
nnoremap 	gf :Tabe <cfile>
nnoremap 	;R :-TabvB 
nnoremap 	;r :TabvB 
nnoremap 	 R :-TabvA 
nnoremap 	 r :TabvA 
nnoremap 	R :-Tabv 
nnoremap 	r :Tabv 
nnoremap <silent> 	k KT
nnoremap 	H :-tab help 
nnoremap 	h :tab help 
nnoremap 	sr :botright vsplit 
nnoremap 	sd :botright split 
nnoremap 	ss :split 
nnoremap 	sv :vsplit 
nnoremap <silent> 	^D :resize -20
nnoremap <silent> 	^d :resize -10
nnoremap <silent> 	^_ :resize -5
nnoremap <silent> 	^- :resize -1
nnoremap <silent> 	^A :resize +20
nnoremap <silent> 	^a :resize +10
nnoremap <silent> 	^+ :resize +5
nnoremap <silent> 	^= :resize +1
nnoremap <silent> 	^r :resize  
nnoremap <silent> 	^5 :resize 50
nnoremap <silent> 	^4 :resize 40
nnoremap <silent> 	^3 :resize 30
nnoremap <silent> 	^2 :resize 20
nnoremap <silent> 	^1 :resize 10
nnoremap <silent> 	>D :vertical resize -20
nnoremap <silent> 	>d :vertical resize -10
nnoremap <silent> 	>_ :vertical resize -5
nnoremap <silent> 	>- :vertical resize -1
nnoremap <silent> 	>A :vertical resize +20
nnoremap <silent> 	>a :vertical resize +10
nnoremap <silent> 	>+ :vertical resize +5
nnoremap <silent> 	>= :vertical resize +1
nnoremap 	>r :vertical resize  
nnoremap <silent> 	>5 :vertical resize 50
nnoremap <silent> 	>4 :vertical resize 40
nnoremap <silent> 	>3 :vertical resize 30
nnoremap <silent> 	>2 :vertical resize 20
nnoremap <silent> 	>1 :vertical resize 10
nnoremap 	: :tabdo 
nnoremap <silent> 	K :tabm 0
nnoremap <silent> 	J :tabm $
nnoremap <silent> 	P :execute 'tabmove -'.v:count1
nnoremap <silent> 	N :execute 'tabmove +'.v:count1
nnoremap 	m :tabm 
nnoremap 	p gT
nnoremap <silent> 	n :call SwitchTab(v:count1)
nnoremap <silent> 	$ :tablast
nnoremap <silent> 	0 :tabfirst
nnoremap 	B :-tab sb 
nnoremap 	b :tab sb 
nnoremap <silent> 	! :tabonly
nnoremap <silent> 	- :tabclosegT
nnoremap <silent> 	+ :tabnew
nnoremap 	 l :filter  tabs<C-Left><Left>
nnoremap 	l :tabs
nnoremap 	gP :-tabfind 
nnoremap 	gp :tabfind 
nnoremap 	<S-Tab> :-tab 
nnoremap 		 :tab 
nnoremap <silent> <expr> 	;e(v:count ? ':exe "tabnext "'.v:count.'' : '')
nnoremap 	;O :-TabB 
nnoremap 	;o :TabB 
nnoremap 	 O :-TabA 
nnoremap 	 o :TabA 
nnoremap 	O :-Tabe 
nnoremap 	o :Tabe 
xnoremap 	U "*P
xnoremap 	u "*p
xnoremap 	Y "*Y
xnoremap 	y "*y
nnoremap 	U "*P
nnoremap 	u "*p
nnoremap 	Y "*Y
nnoremap 	y "*y
noremap <NL> 	
noremap  <Plug>Sneak_;
noremap  <Plug>Sneak_,
xmap  <Plug>VSurround
noremap ,xf p :tabnew:PeditVifm 
noremap ,xf d :tabnew:DiffVifm 
noremap ,xf f :tabnew:EditVifm 
noremap ,xfp :tabnew:PeditVifm
noremap ,xfd :tabnew:DiffVifm
noremap ,xff :tabnew:EditVifm
nnoremap ,xo :exe 'tabedit '. system('dragon --on-top --target --and-exit '. '2>/dev/null') :redraw
nnoremap <silent> ;W :call QFcmd("window '.g:qfheight", "exe '")T
nnoremap <silent> ;w :call QFcmd("open '.g:qfheight", "exe '")T
nmap gf :Tabe <cfile>
nnoremap  :exe 'tab tag '.Expand('<cword>')
xmap  <Plug>SpeedDatingDown
nmap  <Plug>SpeedDatingDown
noremap <expr>  f- g:qfloc ? ':Lfilter /^grep: /' : ':Cfilter /^grep: /'
noremap <expr>  bP g:qfloc ? ':Llocate! '.getreg('+').'' : ':Cllocate! '.getreg('+').''
noremap <expr>  bp g:qfloc ? ':Llocate '.getreg('+').'' : ':Cllocate '.getreg('+').''
noremap <expr>  bG g:qfloc ? ':Llocate! '.getreg('*').'' : ':Cllocate! '.getreg('*').''
noremap <expr>  bg g:qfloc ? ':Llocate '.getreg('*').'' : ':Cllocate '.getreg('*').''
noremap <expr>  bY g:qfloc ? ':Llocate! '.getreg('"').'' : ':Cllocate! '.getreg('"').''
noremap <expr>  by g:qfloc ? ':Llocate '.getreg('"').'' : ':Cllocate '.getreg('"').''
noremap <expr>  bE g:qfloc ? ':Llocate! <cexpr>' : ':Cllocate! <cexpr>'
noremap <expr>  be g:qfloc ? ':Llocate <cexpr>' : ':Cllocate <cexpr>'
noremap <expr>  bM g:qfloc ? ':Llocate! <cWORD>' : ':Cllocate! <cWORD>'
noremap <expr>  bm g:qfloc ? ':Llocate <cWORD>' : ':Cllocate <cWORD>'
noremap <expr>  bW g:qfloc ? ':Llocate! <cword>' : ':Cllocate! <cword>'
noremap <expr>  bw g:qfloc ? ':Llocate <cword>' : ':Cllocate <cword>'
noremap <expr>  bU g:qfloc ? ':Llocate! <cfile>' : ':Cllocate! <cfile>'
noremap <expr>  bu g:qfloc ? ':Llocate <cfile>' : ':Cllocate <cfile>'
noremap <expr>  bS g:qfloc ? ":exe 'Llocate! \"'.GetVisualEsc().'\"'" : ":exe 'Clocate! \"'.GetVisualEsc().'\"'"
noremap <expr>  bs g:qfloc ? ":exe 'Llocate \"'.GetVisualEsc().'\"'" : ":exe 'Clocate \"'.GetVisualEsc().'\"'"
noremap  bC g:qfloc ? ':Llocate! ' : ':Clocate! '
noremap  bc g:qfloc ? ':Llocate ' : ':Clocate '
noremap <expr>  ?P g:qfloc ? ':Lfind! . -type f -name "'.getreg('+').'"' : ':Cfind! . -type f -name "'.getreg('+').'"'
noremap <expr>  ?p g:qfloc ? ':Lfind . -type f -name "'.getreg('+').'"' : ':Cfind . -type f -name "'.getreg('+').'"'
noremap <expr>  ?G g:qfloc ? ':Lfind! . -type f -name "'.getreg('*').'"' : ':Cfind! . -type f -name "'.getreg('*').'"'
noremap <expr>  ?g g:qfloc ? ':Lfind . -type f -name "'.getreg('*').'"' : ':Cfind . -type f -name "'.getreg('*').'"'
noremap <expr>  ?Y g:qfloc ? ':Lfind! . -type f -name "'.getreg('"').'"' : ':Cfind! . -type f -name "'.getreg('"').'"'
noremap <expr>  ?y g:qfloc ? ':Lfind . -type f -name "'.getreg('"').'"' : ':Cfind . -type f -name "'.getreg('"').'"'
noremap <expr>  ?E g:qfloc ? ':Lfind! . -type f -name "<cexpr>"' : ':Cfind! . -type f -name "<cexpr>"'
noremap <expr>  ?e g:qfloc ? ':Lfind . -type f -name "<cexpr>"' : ':Cfind . -type f -name "<cexpr>"'
noremap <expr>  ?M g:qfloc ? ':Lfind! . -type f -name "<cWORD>"' : ':Cfind! . -type f -name "<cWORD>"'
noremap <expr>  ?m g:qfloc ? ':Lfind . -type f -name "<cWORD>"' : ':Cfind . -type f -name "<cWORD>"'
noremap <expr>  ?W g:qfloc ? ':Lfind! . -type f -name "<cword>"' : ':Cfind! . -type f -name "<cword>"'
noremap <expr>  ?w g:qfloc ? ':Lfind . -type f -name "<cword>"' : ':Cfind . -type f -name "<cword>"'
noremap <expr>  ?U g:qfloc ? ':Lfind! . -type f -name "<cfile>"' : ':Cfind! . -type f -name "<cfile>"'
noremap <expr>  ?u g:qfloc ? ':Lfind . -type f -name "<cfile>"' : ':Cfind . -type f -name "<cfile>"'
noremap <expr>  ?S g:qfloc ? ":exe 'Lfind! . -type f -name ". "\"'.GetVisualEsc().'\"'" : ":exe 'Cfind! . -type f -name ". "\"'.GetVisualEsc().'\"'"
noremap <expr>  ?s g:qfloc ? ":exe 'Lfind . -type f -name ". "\"'.GetVisualEsc().'\"'" : ":exe 'Cfind . -type f -name ". "\"'.GetVisualEsc().'\"'"
noremap <expr>  /P g:qfloc ? ':Lfind! . -type f -name "*'.getreg('+').'*"' : ':Cfind! . -type f -name "*'.getreg('+').'*"'
noremap <expr>  /p g:qfloc ? ':Lfind . -type f -name "*'.getreg('+').'*"' : ':Cfind . -type f -name "*'.getreg('+').'*"'
noremap <expr>  /G g:qfloc ? ':Lfind! . -type f -name "*'.getreg('*').'*"' : ':Cfind! . -type f -name "*'.getreg('*').'*"'
noremap <expr>  /g g:qfloc ? ':Lfind . -type f -name "*'.getreg('*').'*"' : ':Cfind . -type f -name "*'.getreg('*').'*"'
noremap <expr>  /Y g:qfloc ? ':Lfind! . -type f -name "*'.getreg('"').'*"' : ':Cfind! . -type f -name "*'.getreg('"').'*"'
noremap <expr>  /y g:qfloc ? ':Lfind . -type f -name "*'.getreg('"').'*"' : ':Cfind . -type f -name "*'.getreg('"').'*"'
noremap <expr>  /E g:qfloc ? ':Lfind! . -type f -name "*<cexpr>*"' : ':Cfind! . -type f -name "*<cexpr>*"'
noremap <expr>  /e g:qfloc ? ':Lfind . -type f -name "*<cexpr>*"' : ':Cfind . -type f -name "*<cexpr>*"'
noremap <expr>  /M g:qfloc ? ':Lfind! . -type f -name "*<cWORD>*"' : ':Cfind! . -type f -name "*<cWORD>*"'
noremap <expr>  /m g:qfloc ? ':Lfind . -type f -name "*<cWORD>*"' : ':Cfind . -type f -name "*<cWORD>*"'
noremap <expr>  /W g:qfloc ? ':Lfind! . -type f -name "*<cword>*"' : ':Cfind! . -type f -name "*<cword>*"'
noremap <expr>  /w g:qfloc ? ':Lfind . -type f -name "*<cword>*"' : ':Cfind . -type f -name "*<cword>*"'
noremap <expr>  /U g:qfloc ? ':Lfind! . -type f -name "*<cfile>*"' : ':Cfind! . -type f -name "*<cfile>*"'
noremap <expr>  /u g:qfloc ? ':Lfind . -type f -name "*<cfile>*"' : ':Cfind . -type f -name "*<cfile>*"'
noremap <expr>  /S g:qfloc ? ":exe 'Lfind! . -type f -name ".'"*'. "'.GetVisualEsc().'".'*"' : ":exe 'Cfind! . -type f -name ".'"*'. "'.GetVisualEsc().'".'*"'
noremap <expr>  /s g:qfloc ? ":exe 'Lfind . -type f -name ".'"*'. "'.GetVisualEsc().'".'*"' : ":exe 'Cfind . -type f -name ".'"*'. "'.GetVisualEsc().'".'*"'
noremap <expr>  ?A g:qfloc ? ':Lfind! . -xtype d -name ""<Left>' : ':Cfind! . -xtype d -name ""<Left>'
noremap <expr>  ?a g:qfloc ? ':Lfind . -xtype d -name ""<Left>' : ':Cfind . -xtype d -name ""<Left>'
noremap <expr>  ?L g:qfloc ? ':Lfind! . -xtype f -name ""<Left>' : ':Cfind! . -xtype f -name ""<Left>'
noremap <expr>  ?l g:qfloc ? ':Lfind . -xtype f -name ""<Left>' : ':Cfind . -xtype f -name ""<Left>'
noremap <expr>  ?D g:qfloc ? ':Lfind! . -type d -name ""<Left>' : ':Cfind! . -type d -name ""<Left>'
noremap <expr>  ?d g:qfloc ? ':Lfind . -type d -name ""<Left>' : ':Cfind . -type d -name ""<Left>'
noremap <expr>  ?F g:qfloc ? ':Lfind! . -type f -name ""<Left>' : ':Cfind! . -type f -name ""<Left>'
noremap <expr>  ?f g:qfloc ? ':Lfind . -type f -name ""<Left>' : ':Cfind . -type f -name ""<Left>'
noremap <expr>  /A g:qfloc ? ':Lfind! . -xtype d -name "**"<Left><Left>' : ':Cfind! . -xtype d -name "**"<Left><Left>'
noremap <expr>  /a g:qfloc ? ':Lfind . -xtype d -name "**"<Left><Left>' : ':Cfind . -xtype d -name "**"<Left><Left>'
noremap <expr>  /L g:qfloc ? ':Lfind! . -xtype f -name "**"<Left><Left>' : ':Cfind! . -xtype f -name "**"<Left><Left>'
noremap <expr>  /l g:qfloc ? ':Lfind . -xtype f -name "**"<Left><Left>' : ':Cfind . -xtype f -name "**"<Left><Left>'
noremap <expr>  /D g:qfloc ? ':Lfind! . -type d -name "**"<Left><Left>' : ':Cfind! . -type d -name "**"<Left><Left>'
noremap <expr>  /d g:qfloc ? ':Lfind . -type d -name "**"<Left><Left>' : ':Cfind . -type d -name "**"<Left><Left>'
noremap <expr>  /F g:qfloc ? ':Lfind! . -type f -name "**"<Left><Left>' : ':Cfind! . -type f -name "**"<Left><Left>'
noremap <expr>  /f g:qfloc ? ':Lfind . -type f -name "**"<Left><Left>' : ':Cfind . -type f -name "**"<Left><Left>'
noremap  /C g:qfloc ? ':Lfind! ' : ':Cfind! '
noremap  /c g:qfloc ? ':Lfind ' : ':Cfind '
nnoremap  tqc :GutentagsClearCache
nnoremap  tqt :GutentagsToggleTrace
nnoremap  tqg :GutentagsToggleEnabled
nnoremap  mC; :compiler! 
nnoremap  mc; :compiler 
nnoremap  mc  :SelectCompiler 
nnoremap  mF :set errorformat= 
nnoremap  mqF :set errorformat
nnoremap  mP :set makeprg=
nnoremap  mqP :set makeprg
nnoremap  mf :setlocal errorformat= 
nnoremap  mqf :setlocal errorformat
nnoremap  mp :setlocal makeprg=
nnoremap  mqp :setlocal makeprg
nnoremap <expr>  me ':setlocal makeprg='.&makeprg
nnoremap <expr>  m r g:qfloc ? ':lmake ' : ':make '
nnoremap <expr>  mr g:qfloc ? ':lmake' : ':make'
nnoremap <silent>  hu :diffupdate
nnoremap <silent>  ht  :diffthis 
nnoremap <silent>  htc :diffthis
nnoremap <silent>  hoc :diffoff
nnoremap <silent>  1F :call DiffGet(Expand('%:t'))
nnoremap <silent>  1f :call DiffGet(Expand('%:p'))
nnoremap <silent>  2F :call DiffPut(Expand('%:t'))
nnoremap <silent>  2f :call DiffPut(Expand('%:p'))
nnoremap <silent>  2b :call DiffPut('_BASE_')
nnoremap <silent>  2r :call DiffPut('_REMOTE_')
nnoremap <silent>  2l :call DiffPut('_LOCAL_')
nnoremap <silent>  23 :call DiffPut('//3')
nnoremap <silent>  22 :call DiffPut('//2')
nnoremap <silent>  21 :call DiffPut('//1')
nnoremap <silent>  20 :call DiffPut('//0')
nnoremap <silent>  1b :call DiffGet('_BASE_')
nnoremap <silent>  1r :call DiffGet('_REMOTE_')
nnoremap <silent>  1l :call DiffGet('_LOCAL_')
nnoremap <silent>  13 :call DiffGet('//3')
nnoremap <silent>  12 :call DiffGet('//2')
nnoremap <silent>  11 :call DiffGet('//1')
nnoremap <silent>  10 :call DiffGet('//0')
nnoremap <silent>  1  :diffget 
nnoremap <silent>  2  :diffput 
nnoremap <silent>  1c :diffget
nnoremap <silent>  2c :diffput
nnoremap  X :perl
nnoremap  x :perldo
nnoremap  g% /\%V
nnoremap  g? /\V
nnoremap  g/ /\v
map  } ]%
map  { [%
xnoremap  in :exe 'g/'.GetVisualSelection().'/#'
nnoremap  ins :exe 'g/'.GetVisualSelection().'/#'
nnoremap  inp :exe 'g/'.getreg('+').'/#'
nnoremap  ing :exe 'g/'.getreg('*').'/#'
nnoremap  iny :exe 'g/'.getreg('"').'/#'
nnoremap  ine :exe 'g/'.expand('<cexpr>').'/#'
nnoremap  inf :exe 'g/'.expand('<cfile>').'/#'
nnoremap  inw :exe 'g/'.expand('<cWORD>').'/#'
nnoremap  inu :exe 'g/'.expand('<cword>').'/#'
nnoremap <expr>  is g:qfloc ?':lhelpgrep ' : ':helpgrep '
xnoremap  i m :exe 'filter '. GetVisualSelection().' marks'<C-Left>
xnoremap  i o :exe 'filter '. GetVisualSelection().' files'<C-Left>
xnoremap  i j :exe 'filter '. GetVisualSelection().' jumps'<C-Left>
xnoremap  i c :exe 'filter '. GetVisualSelection().' changes'<C-Left>
xnoremap  i p :exe 'filter '. GetVisualSelection().' history'<C-Left>
xnoremap  i r :exe 'filter '. GetVisualSelection().' registers'<C-Left>
nnoremap  i/ :isearch //<Left>
nnoremap  il :ilist //<Left>
nnoremap <silent>  ;D :call BDArgD()
nnoremap  ga :argadd <cfile>
nnoremap  gF :argedit! <cfile>
nnoremap  gf :argedit <cfile>
nnoremap  ;a :ArgaddB 
xnoremap  ;l :exe 'filter '. GetVisualSelection().' args'
nnoremap  ;O :ArgeditB! 
nnoremap  ;o :ArgeditB 
xnoremap   ;L :exe 'filter '. GetVisualSelection().' buffers!'
xnoremap   ;l :exe 'filter '. GetVisualSelection().' buffers'
nnoremap   gf :edit <cfile>
nnoremap  t A :ltag! 
nnoremap <silent>  tA :ltag! 
nnoremap  t a :ltag 
nnoremap <silent>  ta :ltag
nnoremap  t b :!ctags -R  &<Left><Left>
nnoremap <silent>  tb :!ctags -R &
nnoremap  t r :!ctags -R 
nnoremap  tr :!ctags -R
nnoremap <silent>  t;$ :tlast!
nnoremap <silent>  t$ :tlast
nnoremap <silent>  t;0 :tfirst!
nnoremap <silent>  t0 :tfirst
nnoremap <silent>  tK :exe v:count1.'tprevious!'
nnoremap <silent>  tk :exe v:count1.'tprevious'
nnoremap <silent>  tJ :exe v:count1.'tnext!'
nnoremap <silent>  tj :exe v:count1.'tnext'
nnoremap <silent>  tG :exe v:count1.'tselect!'
nnoremap <silent>  tg :exe v:count1.'tselect'
nnoremap <silent>  tP :exe v:count1.'pop!'
nnoremap <silent>  tN :exe v:count1.'tag!'
nnoremap <silent>  tp :exe v:count1.'pop'
nnoremap <silent>  tn :exe v:count1.'tag'
nnoremap  t l :filter  tags<C-Left><Left>
nnoremap  tl :tags
nnoremap  qt :call ToggleTagComplete()
noremap  _ "_d
nnoremap  ;m :move 
nnoremap  iJ :clearjumps
nnoremap  q;U :update! ##
nnoremap  q;u :update ##
nnoremap   qU :update! 
nnoremap   qu :update 
nnoremap  qU :update!
nnoremap  qu :update
nnoremap  ih :help 
nnoremap  i n :g//#<Left><Left>
nnoremap  ikc :cmap 
nnoremap  iki :imap 
nnoremap  ikv :vmap 
nnoremap  ikn :nmap 
nnoremap  ikk :map 
nnoremap  i m:<C-U>filter marks<C-Left><Left>
nnoremap  i m:filter marks<C-Left><Left>
nnoremap  i o:<C-U>filter files<C-Left><Left>
nnoremap  i o:filter files<C-Left><Left>
nnoremap  i j:<C-U>filter jumps<C-Left><Left>
nnoremap  i j:filter jumps<C-Left><Left>
nnoremap  i c:<C-U>filter changes<C-Left><Left>
nnoremap  i c:filter changes<C-Left><Left>
nnoremap  i p:<C-U>filter history<C-Left><Left>
nnoremap  i p:filter history<C-Left><Left>
nnoremap  i r:<C-U>filter registers<C-Left><Left>
nnoremap  i r:filter registers<C-Left><Left>
nnoremap  i e:<C-U>filter oldfiles<C-Left><Left>
nnoremap  i e:filter oldfiles<C-Left><Left>
nnoremap  ig :marks ABCDEFGHIJKLMNOPQRSTUVWXYZ
nnoremap  im :marks
nnoremap  io :files
nnoremap  ij :jumps
nnoremap  ic :changes
nnoremap  ip :history
nnoremap  ir :registers
nnoremap  ie :oldfiles
nnoremap  q G :argglobal! 
nnoremap  q g :argglobal 
nnoremap <silent>  qG :argglobal!
nnoremap <silent>  qg :argglobal
nnoremap  qF :exe 'arglocal! '.fnameescape(expand('%'))
nnoremap  qf :exe 'arglocal '.fnameescape(expand('%'))
nnoremap  q L :arglocal! 
nnoremap  q l :arglocal 
nnoremap <silent>  qL :arglocal!
nnoremap <silent>  ql :arglocal
nnoremap  ;: :argdo! 
nnoremap  : :argdo 
nnoremap  @ :argdedupe
nnoremap  = :args! 
nnoremap  ;$ :last! 
nnoremap <silent>  $ :last!
nnoremap  ;0 :first! 
nnoremap <silent>  0 :first!
nnoremap   < :wprevious! 
nnoremap   , :wprevious 
nnoremap <silent>  < :call NextArg(0, 'argument!', 'w')
nnoremap <silent>  , :call NextArg(0, 'argument', 'w')
nnoremap   > :wnext! 
nnoremap   . :wnext 
nnoremap <silent>  > :call NextArg(1, 'argument!', 'w')
nnoremap <silent>  . :call NextArg(1, 'argument', 'w')
nnoremap <silent>  P :call NextArg(0, 'argument!')
nnoremap <silent>  p :call NextArg(0, 'argument')
nnoremap <silent>  N :call NextArg(1, 'argument!')
nnoremap <silent>  n :call NextArg(1, 'argument')
nnoremap <silent>  D :call ArgD()
nnoremap  d :argdelete 
nnoremap <silent>  A :argadd|call NextArg(1, 'argument')
nnoremap  a :argadd 
nnoremap  R :ArgView! 
nnoremap  r :ArgView 
nnoremap  O :argedit! 
nnoremap  o :argedit 
nnoremap <silent>  ;E :exe 'argument! '.(v:count ? v:count : '')
nnoremap <silent>  ;e :exe 'argument '.(v:count ? v:count : '')
nnoremap  E :Argument! 
nnoremap  e :Argument 
nnoremap  ;l :filter  args<C-Left><Left>
nnoremap  l :args
nnoremap   ;: :bufdo! 
nnoremap   : :bufdo 
noremap   ;W :Bwip! 
noremap   ;w :Bwip 
noremap   ;U :Bunl! 
noremap   ;u :Bunl 
noremap   ;D :Bdel! 
noremap   ;d :Bdel 
nnoremap   a :Badd 
nnoremap   A :balt 
nnoremap   ;M :bmodified! 
nnoremap   ;m :bmodified 
nnoremap   ;P :bprevious! 
nnoremap   ;N :bnext! 
nnoremap   ;p :bprevious 
nnoremap   ;n :bnext 
noremap <silent>   W :Bwip!
noremap <silent>   w :Bwip
nnoremap <silent>   D :bunload!
nnoremap <silent>   d <Plug>Kwbd
nnoremap   ;$ :blast! 
nnoremap <silent>   $ :blast!
nnoremap   ;0 :bfirst! 
nnoremap <silent>   0 :bfirst!
nnoremap <silent>   M :exe v:count1.'bmodified!'
nnoremap <silent>   m :exe v:count1.'bmodified'
nnoremap <silent>   P :exe v:count1.'bprevious!'
nnoremap <silent>   N :exe v:count1.'bnext!'
nnoremap <silent>   p :exe v:count1.'bprevious'
nnoremap <silent>   n :exe v:count1.'bnext'
nnoremap   ;L :filter  buffers!<C-Left><Left>
nnoremap   ;l :filter  buffers<C-Left><Left>
nnoremap   L :buffers!
nnoremap   l :buffers
noremap <silent>   ;- :Bdel!
noremap <silent>   - :Bdel
nnoremap <silent>   + :enew
nnoremap   R :view! 
nnoremap   r :view 
nnoremap   O :Edit! 
nnoremap   o :Edit 
nnoremap   s 
nnoremap <silent>   ;E :exe'buffer! '.(v:count ? v:count : '')
nnoremap <silent>   ;e :exe'buffer '.(v:count ? v:count : '')
nnoremap   E :buffer! 
nnoremap   e :buffer 
nnoremap  qh :set hls!
nnoremap  qM :setlocal modeline!
nnoremap  qm :setlocal modeline!:e
nnoremap  qs :source %
nnoremap  qW :set wrap!
nnoremap  qw :setlocal wrap!
noremap  i <Nop>
noremap  ; <Nop>
map    <Nop>
map   <Nop>
nnoremap  	 
xnoremap  U "+P
xnoremap  u "+p
xnoremap  Y "+Y
xnoremap  y "+y
nnoremap  U "+P
nnoremap  u "+p
nnoremap  Y "+Y
nnoremap  y "+y
omap <silent> % <Ignore><Plug>(matchup-%)
xmap <silent> % <Plug>(matchup-%)
nmap <silent> % <Plug>(matchup-%)
nnoremap <silent> '[ :call signature#mark#Goto("prev", "line", "alpha")
nnoremap <silent> '] :call signature#mark#Goto("next", "line", "alpha")
nnoremap + <Plug>(signify-next-hunk)
nnoremap <silent> ,nvs :call DocView('pdf')
nnoremap <silent> ,nvp :call PdfViewerToggle('PrevPdfViewer')
nnoremap <silent> ,nvn :call PdfViewerToggle('NextPdfViewer')
nmap <silent> ,d;v :TestVisit
nmap <silent> ,d;l :TestLast
nmap <silent> ,d;s :TestSuite
nmap <silent> ,d;f :TestFile
nmap <silent> ,d;n :TestNearest
noremap ,iu :InfoUp
noremap ,ip :InfoPrev
noremap ,in :InfoNext
noremap ,im i :Index 
noremap ,imi :Index
noremap ,im g :GotoNode 
noremap ,img :GotoNode
noremap ,im o :Follow 
noremap ,imo :Follow
noremap ,im m :Menu 
noremap ,imm :Menu
noremap ,imf :exe 'Info '.expand('<cfile>')
noremap ,imw :exe 'Info '.expand('<cWORD>')
noremap ,imu :exe 'Info '.expand('<cword>')
noremap ,imc :Info 
noremap <silent> ,hT :Hi===
noremap <silent> ,ht :Hi==
noremap <silent> ,h= :Hi=
noremap <silent> <expr> ,hb ':'.v:count1.'Hi/previous'
noremap <silent> <expr> ,hf ':'.v:count1.'Hi/next'
noremap <silent> <expr> ,hi ':'.v:count1.'Hi/never'
noremap <silent> <expr> ,ho ':'.v:count1.'Hi/older'
noremap <silent> ,h/ :Hi//
noremap <silent> <expr> ,hN ':'.v:count1.'Hi]'
noremap <silent> <expr> ,hP ':'.v:count1.'Hi['
noremap <silent> <expr> ,hn ':'.v:count1.'Hi>'
noremap <silent> <expr> ,hp ':'.v:count1.'Hi<'
noremap <silent> <expr> ,hj ':'.v:count1.'Hi}'
noremap <silent> <expr> ,hk ':'.v:count1.'Hi{'
noremap ,hl :Hi >>
noremap <silent> ,hw :Hi/open
noremap <silent> ,hc :Hi/close
noremap <silent> ,qsg :exe 'SignatureListGlobalMarks ' .v:count1
noremap <silent> ,qsl :exe 'SignatureListBufferMarks ' .v:count1
noremap <silent> ,qsr :SignatureRefresh
noremap <silent> ,qst :SignatureToggleSigns
noremap ,ib :B
noremap ,is :S
nnoremap <silent> ,qP :silent! PlugClean!
nnoremap <silent> ,qu :silent! call GeneralUpgrade()
nnoremap <expr> ,usS ':Obsession '.g:data_dir.'/sessions/'
nnoremap ,uss :execute 'Obsession '.g:data_dir. '/sessions/'.localtime().'.vim'
nnoremap ,usr :Obsession!
nnoremap ,usO :Obsession 
nnoremap ,uso :Obsession
nnoremap <expr> ,usD ':mksession '.g:data_dir.'/sessions/'
nnoremap ,usd :execute 'mksession '.g:data_dir. '/sessions/'.localtime().'.vim'
noremap <silent> ,ut :UndotreeToggleWw
noremap ,un :MT 
noremap ,uh :MV 
noremap ,uv :MS 
noremap ,ue :ME 
map ,u <Nop>
nnoremap <silent> ,G :Git
noremap ,xf p :PeditVifm 
noremap ,xf d :DiffVifm 
noremap ,xf t :TabVifm 
noremap ,xf h :SplitVifm 
noremap ,xf s :VsplitVifm 
noremap ,xf f :EditVifm 
noremap ,xfp :PeditVifm
noremap ,xfd :DiffVifm
noremap ,xft :TabVifm
noremap ,xfh :SplitVifm
noremap ,xfs :VsplitVifm
noremap ,xff :EditVifm
nnoremap <silent> ,;sa :Wall
nnoremap <silent> ,;s e :SudoEdit 
nnoremap <silent> ,;se :SudoEdit
nnoremap <silent> ,;s w :SudoWrite 
nnoremap <silent> ,;sw :SudoWrite
nnoremap <expr> ,lp ":call CmdCount('TagbarJumpPrev', ".v:count1.")"
nnoremap <expr> ,ln ":call CmdCount('TagbarJumpNext', ".v:count1.")"
nnoremap ,lu :TagbarForceUpdate
noremap ,l t :TagbarCurrentTag 
nnoremap ,lt :TagbarCurrentTag
nnoremap ,ls :TagbarTogglePause
nnoremap ,lE :TagbarOpenAutoClose
nnoremap ,le :TagbarToggle
nnoremap ,qa :call AutoPairsToggle()
nnoremap ,np;t 03lx:call PLR()P
nnoremap ,npt 0wwv$hy/=@,npTnn
nnoremap <silent> ,np;a :call PlutoAdd(1)
nnoremap <silent> ,npa :call PlutoAdd()
nnoremap <silent> ,npc :exe 'norm i# ╔═╡ '.NuuidNewUuid()
nnoremap <silent> ,qdl :DirenvExport
nnoremap <silent> ,qdE :EditDirenvrc
nnoremap <silent> ,qde :EditEnvrc
noremap <expr> ,nlt LaTeXtoUnicode#Toggle()
noremap ,d m :Neoformat 
noremap <silent> ,dm :Neoformat
map <silent> ,nrs <Plug>ReplaceWithStraight
map <silent> ,nrc <Plug>ReplaceWithCurly
map <silent> ,qs <Plug>ReplaceWithStraight
nnoremap ,ii :call InsertAlignToggle()
xnoremap ,i;@ :Tabularize /@zs
nnoremap ,i;@ :Tabularize /@zs
xnoremap ,i;& :Tabularize /&zs
nnoremap ,i;& :Tabularize /&zs
xnoremap ,i;; :Tabularize /;zs
nnoremap ,i;; :Tabularize /;zs
xnoremap ,i;: :Tabularize /:zs
nnoremap ,i;: :Tabularize /:zs
xnoremap ,i;= :Tabularize /=zs
nnoremap ,i;= :Tabularize /=zs
xnoremap ,i@ :Tabularize /@
nnoremap ,i@ :Tabularize /@
xnoremap ,i& :Tabularize /&
nnoremap ,i& :Tabularize /&
xnoremap ,i; :Tabularize /;
nnoremap ,i; :Tabularize /;
xnoremap ,i: :Tabularize /:
nnoremap ,i: :Tabularize /:
xnoremap ,i= :Tabularize /=
nnoremap ,i= :Tabularize /=
xnoremap ,ic :Tabularize /
nnoremap ,ic :Tabularize /
noremap <silent> ,na :NuuidToggleAbbrev
noremap <silent> ,ng :exe 'norm a'.NuuidNewUuid()
noremap <silent> ,nn :NuuidAll
vmap ,u <Plug>Nuuid
nmap ,u <Plug>Nuuid
noremap <silent> ,dd :call JumpToDef()
nnoremap <silent> ,mi :InlineEdit
nnoremap <silent> ,qer :EditorConfigReload
nnoremap ,qeg :let g:EditorConfig_disable=!g:EditorConfig_disable |echo g:EditorConfig_disable
nnoremap ,qeb :let b:EditorConfig_disable=!b:EditorConfig_disable |echo b:EditorConfig_disable
nnoremap <silent> ,qmp :call PrevFtManOpenMode()
nnoremap <silent> ,qmn :call NextFtManOpenMode()
map ,iwr <Plug>RestoreWinPosn
map ,iws <Plug>SaveWinPosn
noremap ,nm <Plug>(MakeDigraph)
nnoremap <silent> ,tq :Tmux kill-pane -t {last} 
nnoremap ,tL :Tmux list-panes
noremap <silent> ,tv :Tmux send-keys -t {last} C-l
nnoremap <silent> ,tP :Tmux select-pane -m
nnoremap <silent> ,tp :Tmux select-pane -m -t {last} 
nnoremap ,tt :Tmux
nnoremap ,x;L :Lexplore 
nnoremap <silent> ,x;l :Lexplore
nnoremap ,x;R :Rexplore 
nnoremap <silent> ,x;r :Rexplore
nnoremap ,x;P :Pexplore 
nnoremap <silent> ,x;p :Pexplore
nnoremap ,x;N :Nexplore 
nnoremap <silent> ,x;n :Nexplore
nnoremap ,x;V :Vexplore 
nnoremap <silent> ,x;v :Vexplore
nnoremap ,x;H :Hexplore 
nnoremap <silent> ,x;h :Hexplore
nnoremap ,x;T :Texplore 
nnoremap <silent> ,x;t :Texplore
nnoremap ,x;X :Explore 
nnoremap <silent> ,x;x :Explore
nnoremap ,xo :exe 'edit '. system('dragon --on-top --target --and-exit '. '2>/dev/null') :redraw
nnoremap ,x o :exe 'argedit '. system('dragon --on-top --target --and-exit '. '2>/dev/null') :redraw
nnoremap <silent> ,xY :exe '!dragon --on-top --and-exit '. Expand("<cfile>").' 2>/dev/null &' :redraw!
nnoremap <silent> ,xy :exe '!dragon --on-top --and-exit '. Expand("%").' 2>/dev/null &' :redraw!
nnoremap ,usM :mksession 
nnoremap ,usm :mksession
nnoremap ,;c v :mkvimrc 
nnoremap ,;cv :mkvimrc
nnoremap ,;c x :mkexrc 
nnoremap ,;cx :mkexrc
nnoremap ,;m :messages
nnoremap ,;cp :pwd
nnoremap <silent> ,;wc gg0vG$:w !wc
nnoremap ,;c c :lcd 
nnoremap ,;c l :lcd 
nnoremap ,;cc :silent! cd %:p:h
nnoremap ,;cl :silent! lcd %:p:h
noremap ,;l :!ls
nnoremap ,qca :call ToggleAutochdir()
nnoremap ,qv4 :echo b:vautowrite
nnoremap ,qfW :let g:vautowrite=!g:vautowrite
nnoremap ,qfw :call ToggleBuffer('autowrite')
nnoremap ,qv3 :echo b:vautoread
nnoremap ,qfR :let g:vautoread=!g:vautoread
nnoremap ,qfr :call ToggleBuffer('autoread')
nnoremap ,qv2 :echo b:bufcomp
nnoremap ,qfC :let g:bufcomp=!g:bufcomp
nnoremap ,qfc :let b:bufcomp=!b:bufcomp
nnoremap ,qv1 :echo b:buffmt
nnoremap ,qfF :let g:buffmt=!g:buffmt
nnoremap ,qff :let b:buffmt=!b:buffmt
nnoremap ,qeT :set filetype=
nnoremap ,qet :filetype detect
nnoremap <silent> ,qpm :call ToggleManProg()
nnoremap ,qkw :call Wmt()
nnoremap ,qec :set cursorline!
nnoremap ,qep :set paste!
nnoremap ,qeC :set cursorbind!
nnoremap ,qeN :set number!
nnoremap ,qen :set relativenumber!
noremap ,q <Nop>
nnoremap - <Plug>(signify-prev-hunk)
map . <Plug>(RepeatDot)
noremap ;. .
nnoremap <expr> ;;L g:qfloc ? ':lexpr system("ls --color=never -1 -A -R  | sed -E \"s/$/:1:0\"/")' : ':cexpr system("ls --color=never -1 -A -R | sed -E \"s/$/:1:0\"/")'
nnoremap <expr> ;;l g:qfloc ? ':lexpr system("ls --color=never -1 -A | sed -E \"s/$/:1:0\"/")' : ':cexpr system("ls --color=never -1 -A | sed -E \"s/$/:1:0\"/")'
nnoremap <expr> ;;F g:qfloc ? ':Lfilter! ##<Left>' : ':Cfilter! ##<Left>'
nnoremap <expr> ;;f g:qfloc ? ':Lfilter ##<Left>' : ':Cfilter ##<Left>'
nnoremap <expr> ;F g:qfloc ? ':Lfilter! //<Left>' : ':Cfilter! //<Left>'
nnoremap <expr> ;f g:qfloc ? ':Lfilter //<Left>' : ':Cfilter //<Left>'
nnoremap <expr> ;? g:qfloc ?  ':g//laddexpr Expand("%").":".line(".").":".getline(".") <Home><Right><Right>' : ':g//caddexpr Expand("%").":".line(".").":".getline(".") <Home><Right><Right>'
nnoremap <expr> ;/ g:qfloc ?  ':g//lexpr Expand("%").":".line(".").":".getline(".") <Home><Right><Right>' : ':g//cexpr Expand("%").":".line(".").":".getline(".") <Home><Right><Right>'
nnoremap <expr> ;e g:qfloc ? ':lexpr ' : ':cexpr '
nnoremap <silent> ;= g:qfloc ? ':LocToQf' : ':QfToLoc'
nnoremap <silent> ;C g:qfloc ? ':QfToLoc' : ':LocToQf'
nnoremap <silent> ;c :call QFcmd('expr []')
nnoremap <silent> ;h :call NToggleQuickFix()
nnoremap ;L :call QFcmd('history')
nnoremap ;l :call QFcmd('list')
nnoremap <silent> ;W :call QFcmd("window '.g:qfheight", "exe '")
nnoremap <silent> ;w :call QFcmd("open '.g:qfheight", "exe '")
nnoremap <silent> ;> :call QFcmd('newer '.v:count1)
nnoremap <silent> ;< :call QFcmd('older '.v:count1)
nnoremap <silent> ;G :call QFcmd('bottom')
nnoremap <silent> ;$ :call QFcmd('last')
nnoremap <silent> ;0 :call QFcmd('first')
nnoremap <silent> ;g :call QFsel('cc ', 'll ', '', v:count1)
nnoremap <silent> ;p :call QFcmd('pf', v:count1)
nnoremap <silent> ;n :call QFcmd('nf', v:count1)
nnoremap <silent> ;k :call QFcmd('p', v:count1)
nnoremap <silent> ;j :call QFcmd('n', v:count1)
nnoremap <expr> ;;m g:qfloc ? ':lfdo! ' : ':cfdo! '
nnoremap <expr> ;m g:qfloc ? ':lfdo ' : ':cfdo '
nnoremap <expr> ;;: g:qfloc ? ':ldo! ' : ':cdo! '
nnoremap <expr> ;: g:qfloc ? ':ldo ' : ':cdo '
nnoremap <expr> ; 	 g:qfloc ?  ':lgetfile  ' : ':cgetfile  '
nnoremap <silent> ;	 :call QFcmd('getfile')
nnoremap <expr> ; b g:qfloc ?  ':lgetbuffer  ' : ':cgetbuffer  '
nnoremap <silent> ;B :call QFcmd("getbuffer '.v:count1", "exe '")
nnoremap <silent> ;b :call QFcmd('getbuffer')
nnoremap ;q : echo 'Quickfix is now ' .  (g:qfloc ? 'local' : 'global')
nnoremap ;t :let g:qfloc = !g:qfloc | echo 'Quickfix is now ' .  (g:qfloc ? 'local' : 'global')
vnoremap ?? ?=vis#VisBlockSearch()
xnoremap <silent> @(targets) :call targets#do()
onoremap <silent> @(targets) :call targets#do()
xmap <expr> A targets#e('o', 'A', 'A')
omap <expr> A targets#e('o', 'A', 'A')
nnoremap F <Plug>Sneak_F
xnoremap F <Plug>Sneak_F
onoremap F <Plug>Sneak_F
xmap <expr> I targets#e('o', 'I', 'I')
omap <expr> I targets#e('o', 'I', 'I')
xnoremap J :m '>+1gv=gv
xnoremap K :m '<-2gv=gv
nnoremap N Nzzzv
nnoremap Q <Nop>
nnoremap S <Plug>Sneak_S
xnoremap S <Plug>Sneak_S
onoremap S <Plug>Sneak_S
nnoremap T <Plug>Sneak_T
xnoremap T <Plug>Sneak_T
onoremap T <Plug>Sneak_T
xmap Z <Plug>Sneak_S
omap Z <Plug>Sneak_S
nmap [C 9999[c
nmap [c <Plug>(signify-prev-hunk)
omap <silent> [% <Plug>(matchup-[%)
xmap <silent> [% <Plug>(matchup-[%)
nmap <silent> [% <Plug>(matchup-[%)
nnoremap <silent> [= :call signature#marker#Goto("prev", "any",  v:count)
nnoremap <silent> [- :call signature#marker#Goto("prev", "same", v:count)
nnoremap <silent> [` :call signature#mark#Goto("prev", "spot", "pos")
nnoremap <silent> [' :call signature#mark#Goto("prev", "line", "pos")
nnoremap \K :call dist#man#PreGetPage(0)
nmap ]C 9999]c
nmap ]c <Plug>(signify-next-hunk)
omap <silent> ]% <Plug>(matchup-]%)
xmap <silent> ]% <Plug>(matchup-]%)
nmap <silent> ]% <Plug>(matchup-]%)
nnoremap <silent> ]= :call signature#marker#Goto("next", "any",  v:count)
nnoremap <silent> ]- :call signature#marker#Goto("next", "same", v:count)
nnoremap <silent> ]` :call signature#mark#Goto("next", "spot", "pos")
nnoremap <silent> ]' :call signature#mark#Goto("next", "line", "pos")
nnoremap <silent> `[ :call signature#mark#Goto("prev", "spot", "alpha")
nnoremap <silent> `] :call signature#mark#Goto("next", "spot", "alpha")
omap aeu <Plug>(textobj-url-a)
xmap aeu <Plug>(textobj-url-a)
omap aep <Plug>(textobj-path-next_path-a)
xmap aep <Plug>(textobj-path-next_path-a)
omap aeP <Plug>(textobj-path-prev_path-a)
xmap aeP <Plug>(textobj-path-prev_path-a)
xmap a= <Plug>(textobj-between-a)
omap a= <Plug>(textobj-between-a)
onoremap <silent> aj :normal vaj
xnoremap <expr> aj jdaddy#outer_movement(v:count1)
xmap af <Plug>(textobj-between-a)
omap af <Plug>(textobj-between-a)
omap ab <Plug>(textobj-anyblock-a)
xmap ab <Plug>(textobj-anyblock-a)
omap ap <Plug>(textobj-path-next_path-a)
xmap ap <Plug>(textobj-path-next_path-a)
omap aP <Plug>(textobj-path-prev_path-a)
xmap aP <Plug>(textobj-path-prev_path-a)
omap au <Plug>(textobj-url-a)
xmap au <Plug>(textobj-url-a)
omap <silent> a% <Plug>(matchup-a%)
xmap <silent> a% <Plug>(matchup-a%)
xmap <expr> a targets#e('o', 'a', 'a')
omap <expr> a targets#e('o', 'a', 'a')
xnoremap aee gg0oG$
nmap crb <Plug>RadicalCoerceToBinary
nmap cro <Plug>RadicalCoerceToOctal
nmap crx <Plug>RadicalCoerceToHex
nmap crd <Plug>RadicalCoerceToDecimal
nmap cr <Plug>(abolish-coerce-word)
nmap cS <Plug>CSurround
nmap cs <Plug>Csurround
nnoremap <silent> dm :call signature#utils#Remove(v:count)
nmap d<C-X> <Plug>SpeedDatingNowLocal
nmap d <Plug>SpeedDatingNowLocal
nmap d<C-A> <Plug>SpeedDatingNowUTC
nmap d <Plug>SpeedDatingNowUTC
nmap ds <Plug>Dsurround
nnoremap f <Plug>Sneak_f
xnoremap f <Plug>Sneak_f
onoremap f <Plug>Sneak_f
xnoremap f	 :=highlighter#Find("/x")
nnoremap f	 :=highlighter#Find("/")
nnoremap <silent> f<C-L> :if highlighter#Command("clear") | noh | endif
nnoremap <silent> f :if highlighter#Command("clear") | noh | endif
xnoremap <silent> f<BS> :if highlighter#Command("-x") | noh | endif
nnoremap <silent> f<BS> :if highlighter#Command("-") | noh | endif
xnoremap <silent> f :if highlighter#Command("+x") | noh | endif
nnoremap <silent> f :if highlighter#Command("+") | noh | endif
xmap g<C-S> <Plug>VgSurround
xmap g <Plug>VgSurround
xnoremap gx <ScriptCmd>vim9.Open(getregion(getpos('v'), getpos('.'), { type: mode() })->join())
nnoremap gx <ScriptCmd>vim9.Open(GetWordUnderCursor())
nnoremap <silent> gwaj :exe jdaddy#reformat('jdaddy#outer_pos', v:count1, v:register)
nnoremap <silent> gwij :exe jdaddy#reformat('jdaddy#inner_pos', v:count1, v:register)
nnoremap <silent> gqaj :exe jdaddy#reformat('jdaddy#outer_pos', v:count1)
nnoremap <silent> gqij :exe jdaddy#reformat('jdaddy#inner_pos', v:count1)
omap <silent> g% <Ignore><Plug>(matchup-g%)
xmap <silent> g% <Plug>(matchup-g%)
nmap <silent> g% <Plug>(matchup-g%)
nmap gcu <Plug>Commentary<Plug>Commentary
nmap gcc <Plug>CommentaryLine
omap gc <Plug>Commentary
nmap gc <Plug>Commentary
xmap gc <Plug>Commentary
xmap gA <Plug>RadicalView
nmap gA <Plug>RadicalView
xmap gS <Plug>VgSurround
nnoremap <silent> gC :call css_color#toggle()
nnoremap ga <Plug>(UnicodeGA)
nnoremap gsi <Plug>SlimeParagraphSend
xnoremap gsi <Plug>SlimeRegionSend
xnoremap <silent> gsS :execute 'SlimeSend0 "'.GetVisualSelection().'"'
xnoremap <silent> gss :execute 'SlimeSend1 '.GetVisualSelection()
noremap <silent> gs; :SlimeSend
nnoremap gss <Plug>SlimeLineSend
nnoremap gs <Plug>SlimeMotionSend
nnoremap gs: <Plug>SlimeConfig
omap ieu <Plug>(textobj-url-i)
xmap ieu <Plug>(textobj-url-i)
omap iep <Plug>(textobj-path-next_path-i)
xmap iep <Plug>(textobj-path-next_path-i)
omap ieP <Plug>(textobj-path-prev_path-i)
xmap ieP <Plug>(textobj-path-prev_path-i)
xmap i= <Plug>(textobj-between-i)
omap i= <Plug>(textobj-between-i)
onoremap <silent> ij :normal vij
xnoremap <expr> ij jdaddy#inner_movement(v:count1)
xmap if <Plug>(textobj-between-i)
omap if <Plug>(textobj-between-i)
omap ib <Plug>(textobj-anyblock-i)
xmap ib <Plug>(textobj-anyblock-i)
omap ip <Plug>(textobj-path-next_path-i)
xmap ip <Plug>(textobj-path-next_path-i)
omap iP <Plug>(textobj-path-prev_path-i)
xmap iP <Plug>(textobj-path-prev_path-i)
omap iu <Plug>(textobj-url-i)
xmap iu <Plug>(textobj-url-i)
omap <silent> i% <Plug>(matchup-i%)
xmap <silent> i% <Plug>(matchup-i%)
xmap <expr> i targets#e('o', 'i', 'i')
omap <expr> i targets#e('o', 'i', 'i')
xnoremap iee aee
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
nnoremap <silent> m/ :call signature#mark#List(0, 0)
nnoremap <silent> m<BS> :call signature#marker#Purge()
nnoremap <silent> m- :call signature#mark#Purge("line")
nnoremap <silent> m. :call signature#mark#ToggleAtLine()
nnoremap <silent> m, :call signature#mark#Toggle("next")
nnoremap <silent> m :call signature#utils#Input()
nnoremap n nzzzv
nnoremap s <Plug>Sneak_s
xnoremap s <Plug>Sneak_s
onoremap s <Plug>Sneak_s
nnoremap t <Plug>Sneak_t
xnoremap t <Plug>Sneak_t
onoremap t <Plug>Sneak_t
xnoremap <silent> t :if highlighter#Command("+x%") | noh | endif
nnoremap <silent> t :if highlighter#Command("+%") | noh | endif
nmap ySS <Plug>YSsurround
nmap ySs <Plug>YSsurround
nmap yss <Plug>Yssurround
nmap yS <Plug>YSurround
nmap ys <Plug>Ysurround
nnoremap yaee gg0vG$y`'
omap <silent> z% <Plug>(matchup-z%)
xmap <silent> z% <Plug>(matchup-z%)
nmap <silent> z% <Plug>(matchup-z%)
omap z <Plug>Sneak_s
xmap <C-S> <Plug>VSurround
noremap <C-W>,xf p :tabnew:PeditVifm 
noremap <C-W>,xf d :tabnew:DiffVifm 
noremap <C-W>,xf f :tabnew:EditVifm 
noremap <C-W>,xfp :tabnew:PeditVifm
noremap <C-W>,xfd :tabnew:DiffVifm
noremap <C-W>,xff :tabnew:EditVifm
nnoremap <Plug>(qf-diagnostics-popup-loclist) <ScriptCmd>popup.Show(true)
nnoremap <Plug>(qf-diagnostics-popup-quickfix) <ScriptCmd>popup.Show(false)
map <silent> <ScrollWheelUp> <Plug>(WheelUp)
map <silent> <ScrollWheelDown> <Plug>(WheelDown)
vnoremap <Plug>(WheelRight) :call wheel#HScroll(1, visualmode())
nnoremap <Plug>(WheelRight) :call wheel#HScroll(1, '')
vnoremap <Plug>(WheelLeft) :call wheel#HScroll(0, visualmode())
nnoremap <Plug>(WheelLeft) :call wheel#HScroll(0, '')
vnoremap <Plug>(WheelDown) :call wheel#VScroll(1, visualmode())
nnoremap <Plug>(WheelDown) :call wheel#VScroll(1, '')
vnoremap <Plug>(WheelUp) :call wheel#VScroll(0, visualmode())
nnoremap <Plug>(WheelUp) :call wheel#VScroll(0, '')
nnoremap <silent> <Plug>(accelerated_jk_k_position) :call accelerated#position_driven#command('k')
nnoremap <silent> <Plug>(accelerated_jk_j_position) :call accelerated#position_driven#command('j')
nnoremap <silent> <Plug>(accelerated_jk_gk_position) :call accelerated#position_driven#command('gk')
nnoremap <silent> <Plug>(accelerated_jk_gj_position) :call accelerated#position_driven#command('gj')
nnoremap <silent> <Plug>(accelerated_jk_k) :call accelerated#time_driven#command('k')
nnoremap <silent> <Plug>(accelerated_jk_j) :call accelerated#time_driven#command('j')
nnoremap <silent> <Plug>(accelerated_jk_gk) :call accelerated#time_driven#command('gk')
nnoremap <silent> <Plug>(accelerated_jk_gj) :call accelerated#time_driven#command('gj')
vnoremap <silent> <Plug>(bullets-promote) :BulletPromoteVisual
nnoremap <silent> <Plug>(bullets-promote) :BulletPromote
vnoremap <silent> <Plug>(bullets-demote) :BulletDemoteVisual
nnoremap <silent> <Plug>(bullets-demote) :BulletDemote
nnoremap <silent> <Plug>(bullets-toggle-checkbox) :ToggleCheckbox
nnoremap <silent> <Plug>(bullets-renumber) :RenumberList
vnoremap <silent> <Plug>(bullets-renumber) :RenumberSelection
nnoremap <silent> <Plug>TagalongReapply :call tagalong#Reapply()
nnoremap <silent> <Plug>(git-messenger-scroll-up-half) :call gitmessenger#scroll(bufnr('%'), 'C-u')
nnoremap <silent> <Plug>(git-messenger-scroll-down-half) :call gitmessenger#scroll(bufnr('%'), 'C-d')
nnoremap <silent> <Plug>(git-messenger-scroll-up-page) :call gitmessenger#scroll(bufnr('%'), 'C-b')
nnoremap <silent> <Plug>(git-messenger-scroll-down-page) :call gitmessenger#scroll(bufnr('%'), 'C-f')
nnoremap <silent> <Plug>(git-messenger-scroll-up-1) :call gitmessenger#scroll(bufnr('%'), 'C-y')
nnoremap <silent> <Plug>(git-messenger-scroll-down-1) :call gitmessenger#scroll(bufnr('%'), 'C-e')
nnoremap <silent> <Plug>(git-messenger-into-popup) :call gitmessenger#into_popup(bufnr('%'))
nnoremap <silent> <Plug>(git-messenger-close) :call gitmessenger#close_popup(bufnr('%'))
nnoremap <silent> <Plug>(git-messenger) :GitMessenger
xnoremap <silent> <Plug>(signify-motion-outer-visual) :call sy#util#hunk_text_object(1)
onoremap <silent> <Plug>(signify-motion-outer-pending) :call sy#util#hunk_text_object(1)
xnoremap <silent> <Plug>(signify-motion-inner-visual) :call sy#util#hunk_text_object(0)
onoremap <silent> <Plug>(signify-motion-inner-pending) :call sy#util#hunk_text_object(0)
nnoremap <silent> <expr> <Plug>(signify-prev-hunk) &diff ? '[c' : ":\call sy#jump#prev_hunk(v:count1)\"
nnoremap <silent> <expr> <Plug>(signify-next-hunk) &diff ? ']c' : ":\call sy#jump#next_hunk(v:count1)\"
xmap <expr> <Plug>(textobj-between-i) textobj#between#select_i()
omap <expr> <Plug>(textobj-between-i) textobj#between#select_i()
xmap <expr> <Plug>(textobj-between-a) textobj#between#select_a()
omap <expr> <Plug>(textobj-between-a) textobj#between#select_a()
nmap <silent> <2-LeftMouse> <Plug>(matchup-double-click)
nnoremap <Plug>(matchup-reload) :MatchupReload
nnoremap <silent> <Plug>(matchup-double-click) :call matchup#text_obj#double_click()
onoremap <silent> <Plug>(matchup-a%) :call matchup#text_obj#delimited(0, 0, 'delim_all')
onoremap <silent> <Plug>(matchup-i%) :call matchup#text_obj#delimited(1, 0, 'delim_all')
xnoremap <silent> <Plug>(matchup-a%) :call matchup#text_obj#delimited(0, 1, 'delim_all')
xnoremap <silent> <Plug>(matchup-i%) :call matchup#text_obj#delimited(1, 1, 'delim_all')
onoremap <silent> <Plug>(matchup-Z%) :call matchup#motion#op('Z%')
xnoremap <silent> <SNR>126_(matchup-Z%) :call matchup#motion#jump_inside_prev(1)
nnoremap <silent> <Plug>(matchup-Z%) <Cmd>call matchup#motion#jump_inside_prev(0)
onoremap <silent> <Plug>(matchup-z%) :call matchup#motion#op('z%')
xnoremap <silent> <SNR>126_(matchup-z%) :call matchup#motion#jump_inside(1)
nnoremap <silent> <Plug>(matchup-z%) <Cmd>call matchup#motion#jump_inside(0)
onoremap <silent> <Plug>(matchup-[%) :call matchup#motion#op('[%')
onoremap <silent> <Plug>(matchup-]%) :call matchup#motion#op(']%')
xnoremap <silent> <SNR>126_(matchup-[%) :call matchup#motion#find_unmatched(1, 0)
xnoremap <silent> <SNR>126_(matchup-]%) :call matchup#motion#find_unmatched(1, 1)
nnoremap <silent> <Plug>(matchup-[%) <Cmd>call matchup#motion#find_unmatched(0, 0)
nnoremap <silent> <Plug>(matchup-]%) <Cmd>call matchup#motion#find_unmatched(0, 1)
onoremap <silent> <Plug>(matchup-g%) :call matchup#motion#op('g%')
xnoremap <silent> <SNR>126_(matchup-g%) :call matchup#motion#find_matching_pair(1, 0)
onoremap <silent> <Plug>(matchup-%) :call matchup#motion#op('%')
xnoremap <silent> <SNR>126_(matchup-%) :call matchup#motion#find_matching_pair(1, 1)
nnoremap <silent> <Plug>(matchup-g%) <Cmd>call matchup#motion#find_matching_pair(0, 0)
nnoremap <silent> <Plug>(matchup-%) <Cmd>call matchup#motion#find_matching_pair(0, 1)
nnoremap <silent> <expr> <SNR>126_(wise) empty(g:v_motion_force) ? 'v' : g:v_motion_force
nnoremap <silent> <Plug>(matchup-hi-surround) :call matchup#matchparen#highlight_surrounding()
vnoremap <Plug>SurroundWithSingle :call textobj#quote#surround#surround(0, visualmode())
nnoremap <Plug>SurroundWithSingle :call textobj#quote#surround#surround(0, '')
vnoremap <Plug>SurroundWithDouble :call textobj#quote#surround#surround(1, visualmode())
nnoremap <Plug>SurroundWithDouble :call textobj#quote#surround#surround(1, '')
vnoremap <Plug>ReplaceWithStraight :call textobj#quote#replace#replace(0, visualmode())
nnoremap <Plug>ReplaceWithStraight :call textobj#quote#replace#replace(0, '')
vnoremap <Plug>ReplaceWithCurly :call textobj#quote#replace#replace(1, visualmode())
nnoremap <Plug>ReplaceWithCurly :call textobj#quote#replace#replace(1, '')
nnoremap <silent> <Plug>(CMakeCompileSource) :call cmake4vim#CompileSource()
nnoremap <silent> <Plug>(CCMake) :call cmake4vim#CCMake()
nnoremap <silent> <Plug>(CTestCurrent) :call cmake4vim#CTestCurrent(0)
nnoremap <silent> <Plug>(CTest) :call cmake4vim#CTest(0)
nnoremap <silent> <Plug>(CMakeRun) :call cmake4vim#RunTarget(0)
nnoremap <silent> <Plug>(CMakeInfo) :call utils#window#OpenCMakeInfo()
nnoremap <silent> <Plug>(CMakeClean) :call cmake4vim#CleanCMake()
nnoremap <silent> <Plug>(CMakeBuild) :call cmake4vim#CMakeBuild()
nnoremap <silent> <Plug>(CMakeReset) :call cmake4vim#ResetCMakeCache()
nnoremap <silent> <Plug>(CMakeResetAndReload) :call cmake4vim#ResetAndReloadCMake()
nnoremap <silent> <Plug>(CMake) :call cmake4vim#GenerateCMake()
nmap <silent> <Plug>CommentaryUndo :echoerr "Change your <Plug>CommentaryUndo map to <Plug>Commentary<Plug>Commentary"
nnoremap <nowait> <silent> <Plug>(cosco-commaOrSemiColon) :silent! call cosco#commaOrSemiColon()| silent! call repeat#set("\<Plug>(cosco-commaOrSemiColon)")
nmap <silent> <Plug>RestoreWinPosn :call RestoreWinPosn()
nmap <silent> <Plug>SaveWinPosn :call SaveWinPosn()
vnoremap <Plug>Nuuid c=NuuidNewUuid()
nnoremap <Plug>Nuuid i=NuuidNewUuid()
xmap <C-X> <Plug>SpeedDatingDown
xmap <C-A> <Plug>SpeedDatingUp
nmap <C-X> <Plug>SpeedDatingDown
nmap <C-A> <Plug>SpeedDatingUp
nnoremap <Plug>SpeedDatingFallbackDown 
nnoremap <Plug>SpeedDatingFallbackUp 
nnoremap <silent> <Plug>SpeedDatingNowUTC :call speeddating#timestamp(1,v:count)
nnoremap <silent> <Plug>SpeedDatingNowLocal :call speeddating#timestamp(0,v:count)
xnoremap <silent> <Plug>SpeedDatingDown :call speeddating#incrementvisual(-v:count1)
xnoremap <silent> <Plug>SpeedDatingUp :call speeddating#incrementvisual(v:count1)
nnoremap <silent> <Plug>SpeedDatingDown :call speeddating#increment(-v:count1)
nnoremap <silent> <Plug>SpeedDatingUp :call speeddating#increment(v:count1)
nnoremap <silent> <Plug>RadicalCoerceToBinary :call radical#CoerceToBase(2, v:count)
nnoremap <silent> <Plug>RadicalCoerceToOctal :call radical#CoerceToBase(8, v:count)
nnoremap <silent> <Plug>RadicalCoerceToHex :call radical#CoerceToBase(16, v:count)
nnoremap <silent> <Plug>RadicalCoerceToDecimal :call radical#CoerceToBase(10, v:count)
xnoremap <silent> <Plug>RadicalView :call radical#VisualView(v:count, visualmode())
nnoremap <silent> <Plug>RadicalView :call radical#NormalView(v:count)
nnoremap <silent> <Plug>SurroundRepeat .
omap <Plug>SneakPrevious <Plug>Sneak_,
omap <Plug>SneakNext <Plug>Sneak_;
xmap <Plug>SneakPrevious <Plug>Sneak_,
xmap <Plug>SneakNext <Plug>Sneak_;
nmap <Plug>SneakPrevious <Plug>Sneak_,
nmap <Plug>SneakNext <Plug>Sneak_;
omap <Plug>(SneakStreakBackward) <Plug>SneakLabel_S
omap <Plug>(SneakStreak) <Plug>SneakLabel_s
xmap <Plug>(SneakStreakBackward) <Plug>SneakLabel_S
xmap <Plug>(SneakStreak) <Plug>SneakLabel_s
nmap <Plug>(SneakStreakBackward) <Plug>SneakLabel_S
nmap <Plug>(SneakStreak) <Plug>SneakLabel_s
xmap <Plug>VSneakPrevious <Plug>Sneak_,
xmap <Plug>VSneakNext <Plug>Sneak_;
xmap <Plug>VSneakBackward <Plug>Sneak_S
xmap <Plug>VSneakForward <Plug>Sneak_s
nmap <Plug>SneakBackward <Plug>Sneak_S
nmap <Plug>SneakForward <Plug>Sneak_s
onoremap <silent> <Plug>SneakLabel_S :call sneak#wrap(v:operator, 2, 1, 2, 2)
onoremap <silent> <Plug>SneakLabel_s :call sneak#wrap(v:operator, 2, 0, 2, 2)
xnoremap <silent> <Plug>SneakLabel_S :call sneak#wrap(visualmode(), 2, 1, 2, 2)
xnoremap <silent> <Plug>SneakLabel_s :call sneak#wrap(visualmode(), 2, 0, 2, 2)
nnoremap <silent> <Plug>SneakLabel_S :call sneak#wrap('', 2, 1, 2, 2)
nnoremap <silent> <Plug>SneakLabel_s :call sneak#wrap('', 2, 0, 2, 2)
onoremap <silent> <Plug>Sneak_T :call sneak#wrap(v:operator, 1, 1, 0, 0)
onoremap <silent> <Plug>Sneak_t :call sneak#wrap(v:operator, 1, 0, 0, 0)
xnoremap <silent> <Plug>Sneak_T :call sneak#wrap(visualmode(), 1, 1, 0, 0)
xnoremap <silent> <Plug>Sneak_t :call sneak#wrap(visualmode(), 1, 0, 0, 0)
nnoremap <silent> <Plug>Sneak_T :call sneak#wrap('', 1, 1, 0, 0)
nnoremap <silent> <Plug>Sneak_t :call sneak#wrap('', 1, 0, 0, 0)
onoremap <silent> <Plug>Sneak_F :call sneak#wrap(v:operator, 1, 1, 1, 0)
onoremap <silent> <Plug>Sneak_f :call sneak#wrap(v:operator, 1, 0, 1, 0)
xnoremap <silent> <Plug>Sneak_F :call sneak#wrap(visualmode(), 1, 1, 1, 0)
xnoremap <silent> <Plug>Sneak_f :call sneak#wrap(visualmode(), 1, 0, 1, 0)
nnoremap <silent> <Plug>Sneak_F :call sneak#wrap('', 1, 1, 1, 0)
nnoremap <silent> <Plug>Sneak_f :call sneak#wrap('', 1, 0, 1, 0)
onoremap <silent> <Plug>Sneak_, :call sneak#rpt(v:operator, 1)
onoremap <silent> <Plug>Sneak_; :call sneak#rpt(v:operator, 0)
xnoremap <silent> <Plug>Sneak_, :call sneak#rpt(visualmode(), 1)
xnoremap <silent> <Plug>Sneak_; :call sneak#rpt(visualmode(), 0)
nnoremap <silent> <Plug>Sneak_, :call sneak#rpt('', 1)
nnoremap <silent> <Plug>Sneak_; :call sneak#rpt('', 0)
onoremap <silent> <Plug>SneakRepeat :call sneak#wrap(v:operator, sneak#util#getc(), sneak#util#getc(), sneak#util#getc(), sneak#util#getc())
onoremap <silent> <Plug>Sneak_S :call sneak#wrap(v:operator, 2, 1, 2, 1)
onoremap <silent> <Plug>Sneak_s :call sneak#wrap(v:operator, 2, 0, 2, 1)
xnoremap <silent> <Plug>Sneak_S :call sneak#wrap(visualmode(), 2, 1, 2, 1)
xnoremap <silent> <Plug>Sneak_s :call sneak#wrap(visualmode(), 2, 0, 2, 1)
nnoremap <silent> <Plug>Sneak_S :call sneak#wrap('', 2, 1, 2, 1)
nnoremap <silent> <Plug>Sneak_s :call sneak#wrap('', 2, 0, 2, 1)
xnoremap <silent> <Plug>(QuickScopeToggle) :call quick_scope#Toggle()
nnoremap <silent> <Plug>(QuickScopeToggle) :call quick_scope#Toggle()
xnoremap <expr> <Plug>(QuickScopeWallhacks) quick_scope#Wallhacks()
xnoremap <expr> <Plug>(QuickScopeWallhacksT) quick_scope#Wallhacks("T")
xnoremap <expr> <Plug>(QuickScopeWallhacksF) quick_scope#Wallhacks("F")
onoremap <expr> <Plug>(QuickScopeWallhacks) quick_scope#Wallhacks()
onoremap <expr> <Plug>(QuickScopeWallhacksT) quick_scope#Wallhacks("T")
onoremap <expr> <Plug>(QuickScopeWallhacksF) quick_scope#Wallhacks("F")
nnoremap <expr> <Plug>(QuickScopeWallhacks) quick_scope#Wallhacks()
nnoremap <expr> <Plug>(QuickScopeWallhacksT) quick_scope#Wallhacks("T")
nnoremap <expr> <Plug>(QuickScopeWallhacksF) quick_scope#Wallhacks("F")
noremap <SNR>79_Operator :call slime#store_curpos():set opfunc=slime#send_opg@
onoremap <silent> <Plug>(fzf-maps-o) :call fzf#vim#maps('o', 0)
xnoremap <silent> <Plug>(fzf-maps-x) :call fzf#vim#maps('x', 0)
nnoremap <silent> <Plug>(fzf-maps-n) :call fzf#vim#maps('n', 0)
tnoremap <silent> <Plug>(fzf-normal) 
tnoremap <silent> <Plug>(fzf-insert) i
nnoremap <silent> <Plug>(fzf-normal) <Nop>
nnoremap <silent> <Plug>(fzf-insert) i
nnoremap <C-W>,xo :exe 'tabedit '. system('dragon --on-top --target --and-exit '. '2>/dev/null') :redraw
nnoremap <silent> <C-W>;W :call QFcmd("window '.g:qfheight", "exe '")T
nnoremap <silent> <C-W>;w :call QFcmd("open '.g:qfheight", "exe '")T
nnoremap <silent> <C-@> :exe v:count1.'tag'
nnoremap <silent> <Nul> :exe v:count1.'tag'
snoremap <BS> <BS>i
nmap <C-W>gf :Tabe <cfile>
nnoremap <C-W><C-H> :exe 'tab tag '.Expand('<cword>')
map <C-H> 
nnoremap <silent> <Plug>Kwbd :Kwbd
nnoremap <Plug>ManPreGetPage :call dist#man#PreGetPage(0)
noremap <C-N> <Plug>Sneak_;
noremap <C-P> <Plug>Sneak_,
noremap <C-J> 	
cnoremap  <Home>
inoremap <expr>  pumvisible() ? '' : ''
cnoremap   <BS><Left>
cnoremap <expr>  getcmdpos() <= strlen(getcmdline()) ? "\<Del>" : ""
inoremap <expr>  pumvisible() ? '' : ''
cnoremap  <End>
cnoremap   <BS><Right>
imap <silent> % <Plug>(matchup-c_g%)
imap S <Plug>ISurround
imap s <Plug>Isurround
inoremap <expr>  pumvisible() ? '' : ''
inoremap <expr> 	 pumvisible() ? "" : "	"
inoremap  <Nop>
cnoremap <expr>  p "@+"
cnoremap <expr>  g "@*"
cnoremap <expr>  y "@\""
cnoremap <expr>  f "<cfile>"
cnoremap <expr>  e "<cexpr>"
cnoremap <expr>  c "<cWORD>"
cnoremap <expr>  w "<cword>"
cnoremap <expr> p "=getreg('+')"
cnoremap <expr> g "=getreg('*')"
cnoremap <expr> y "=getreg('\"')"
cnoremap <expr> f "=expand('<cfile>')"
cnoremap <expr> e "=expand('<cexpr>')"
cnoremap <expr> w "=expand('<cWORD>')"
cnoremap <expr> u "=expand('<cword>')"
cnoremap <expr> c "="
cnoremap ; \%V
cnoremap ? \V
cnoremap / \v
imap  <Plug>Isurround
inoremap <expr>  pumvisible() ? '' : ''
cnoremap  
imap s 
imap h 
imap a 
imap g 
inoremap  <Plug>(UnicodeFuzzy)
inoremap  <Plug>(HTMLEntityComplete)
inoremap  <Plug>(UnicodeComplete)
inoremap  <Plug>(DigraphComplete)
imap m 
inoremap <expr>  '=TmuxComplete()'
inoremap c 
inoremap j 
inoremap v 
inoremap u 
inoremap t 
inoremap o 
inoremap l 
inoremap k 
inoremap i 	
inoremap f 
inoremap d 
inoremap  
cnoremap * 
cnoremap = 
cnoremap ? 
cnoremap # "
cnoreabbr info Info
cnoreabbr Abo Abolish
cnoreabbr <expr> MakeshiftBuild (g:qfloc) ? 'LMakeshiftBuild' : 'MakeshiftBuild'
cnoreabbr <expr> Make (g:qfloc) ? 'Lmake' : 'Make'
cnoreabbr Fmt Neoformat
cnoreabbr Tabu Tabularize
inoreabbr <expr> nguid NuuidNewUuid()
inoreabbr <expr> nuuid NuuidNewUuid()
cnoreabbr <expr> make (g:qfloc) ? 'lmake' : 'make'
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set background=dark
set cedit=<C-j>
set cindent
set clipboard=
set cmdwinheight=30
set complete=w,b,s,i,d,.,k
set completeopt=menu,menuone,noselect,noinsert,fuzzy
set diffopt=internal,filler,closeoff,algorithm:patience,context:8
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set formatoptions=croqlwn
set helplang=en
set hidden
set history=10000
set ignorecase
set incsearch
set laststatus=0
set listchars=eol:$,tab:-->,lead:.
set maxmem=2000000
set maxmempattern=2000000
set nomodeline
set modelines=3
set mouse=a
set omnifunc=syntaxcomplete#Complete
set pumheight=20
set ruler
set runtimepath=
set runtimepath+=~/.vim
set runtimepath+=~/.vim/plugged/vim-magnum
set runtimepath+=~/.vim/plugged/vim-repeat
set runtimepath+=~/.vim/plugged/undotree
set runtimepath+=~/.vim/plugged/fzf
set runtimepath+=~/.vim/plugged/fzf.vim
set runtimepath+=~/.vim/plugged/vim-slime
set runtimepath+=~/.vim/plugged/readline.vim
set runtimepath+=~/.vim/plugged/quick-scope
set runtimepath+=~/.vim/plugged/vim-sneak
set runtimepath+=~/.vim/plugged/vim-paragraph-motion
set runtimepath+=~/.vim/plugged/vim-tbone
set runtimepath+=~/.vim/plugged/vim-surround
set runtimepath+=~/.vim/plugged/vim-abolish
set runtimepath+=~/.vim/plugged/lazy-utils
set runtimepath+=~/.vim/plugged/vim-obsession
set runtimepath+=~/.vim/plugged/vim-tinyMRU
set runtimepath+=~/.vim/plugged/vim-radical
set runtimepath+=~/.vim/plugged/vim-eunuch
set runtimepath+=~/.vim/plugged/vim-speeddating
set runtimepath+=~/.vim/plugged/unicode.vim
set runtimepath+=~/.vim/plugged/vim-nuuid
set runtimepath+=~/.vim/plugged/rainbow
set runtimepath+=~/.vim/plugged/vim-signature
set runtimepath+=~/.vim/plugged/vis
set runtimepath+=~/.vim/plugged/vim-bbye
set runtimepath+=~/.vim/plugged/vim-highlighter
set runtimepath+=~/.vim/plugged/tabular
set runtimepath+=~/.vim/plugged/vim-endwise
set runtimepath+=~/.vim/plugged/neoformat
set runtimepath+=~/.vim/plugged/cosco.vim
set runtimepath+=~/.vim/plugged/vim-context-commentstring
set runtimepath+=~/.vim/plugged/vim-commentary
set runtimepath+=~/.vim/plugged/vim-dispatch
set runtimepath+=~/.vim/plugged/tmux-complete.vim
set runtimepath+=~/.vim/plugged/tagbar
set runtimepath+=~/.vim/plugged/vim-gutentags
set runtimepath+=~/.vim/plugged/SingleCompile
set runtimepath+=~/.vim/plugged/vim-compilers
set runtimepath+=~/.vim/plugged/vim-makeshift
set runtimepath+=~/.vim/plugged/cmake4vim
set runtimepath+=~/.vim/plugged/mesonic
set runtimepath+=~/.vim/plugged/targets.vim
set runtimepath+=~/.vim/plugged/vim-indent-object
set runtimepath+=~/.vim/plugged/vim-textobj-quote
set runtimepath+=~/.vim/plugged/vim-textobj-sentence
set runtimepath+=~/.vim/plugged/vim-matchup
set runtimepath+=~/.vim/plugged/vim-textobj-user
set runtimepath+=~/.vim/plugged/vim-textobj-continuous-line
set runtimepath+=~/.vim/plugged/vim-textobj-url
set runtimepath+=~/.vim/plugged/vim-textobj-path
set runtimepath+=~/.vim/plugged/vim-textobj-anyblock
set runtimepath+=~/.vim/plugged/vim-textobj-between
set runtimepath+=~/.vim/plugged/vim-textobj-typst
set runtimepath+=~/.vim/plugged/vim-textobj-markdown
set runtimepath+=~/.vim/plugged/vim-fugitive
set runtimepath+=~/.vim/plugged/gv.vim
set runtimepath+=~/.vim/plugged/vim-signify
set runtimepath+=~/.vim/plugged/git-messenger.vim
set runtimepath+=~/.vim/plugged/vim-rhubarb
set runtimepath+=~/.vim/plugged/fugitive-gitlab.vim
set runtimepath+=~/.vim/plugged/vim-fubitive
set runtimepath+=~/.vim/plugged/direnv.vim
set runtimepath+=~/.vim/plugged/vim-tmux
set runtimepath+=~/.vim/plugged/vifm.vim
set runtimepath+=~/.vim/plugged/vim-nickel
set runtimepath+=~/.vim/plugged/kmonad-vim
set runtimepath+=~/.vim/plugged/autohotkey.vim
set runtimepath+=~/.vim/plugged/julia-vim
set runtimepath+=~/.vim/plugged/vim-pythonsense
set runtimepath+=~/.vim/plugged/vim-minizinc
set runtimepath+=~/.vim/plugged/zig.vim
set runtimepath+=~/.vim/plugged/ansible-vim
set runtimepath+=~/.vim/plugged/haskell-vim
set runtimepath+=~/.vim/plugged/vim-troff
set runtimepath+=~/.vim/plugged/typst.vim
set runtimepath+=~/.vim/plugged/info.vim
set runtimepath+=~/.vim/plugged/tagalong.vim
set runtimepath+=~/.vim/plugged/ebnf-vim
set runtimepath+=~/.vim/plugged/bnf.vim
set runtimepath+=~/.vim/plugged/vim-markdown
set runtimepath+=~/.vim/plugged/vim-pandoc-syntax
set runtimepath+=~/.vim/plugged/bullets.vim
set runtimepath+=~/.vim/plugged/vim-orgmode
set runtimepath+=~/.vim/plugged/vim-rst
set runtimepath+=~/.vim/plugged/vim-asciidoctor
set runtimepath+=~/.vim/plugged/Dockerfile.vim
set runtimepath+=~/.vim/plugged/vim-pandoc
set runtimepath+=~/.vim/plugged/accelerated-jk
set runtimepath+=~/.vim/plugged/vim-wheel
set runtimepath+=~/.vim/plugged/inline_edit.vim
set runtimepath+=~/.vim/plugged/auto-pairs
set runtimepath+=~/.vim/plugged/vim-css-color
set runtimepath+=~/.vim/plugged/vim-cpp-modern
set runtimepath+=~/.vim/plugged/vim-json
set runtimepath+=~/.vim/plugged/vim-jdaddy
set runtimepath+=~/.vim/plugged/vim-elixir
set runtimepath+=~/.vim/plugged/vim-qf-diagnostics
set runtimepath+=~/.vim/plugged/vim-simple-complete
set runtimepath+=/nix/store/hzv94c2j54lsg4qv9b47szn2jqmzcixr-svim/share/vim/vimfiles
set runtimepath+=/nix/store/hzv94c2j54lsg4qv9b47szn2jqmzcixr-svim/share/vim/vim91
set runtimepath+=/nix/store/hzv94c2j54lsg4qv9b47szn2jqmzcixr-svim/share/vim/vim91/pack/dist/opt/netrw
set runtimepath+=/nix/store/hzv94c2j54lsg4qv9b47szn2jqmzcixr-svim/share/vim/vim91/pack/dist/opt/editorconfig
set runtimepath+=/nix/store/hzv94c2j54lsg4qv9b47szn2jqmzcixr-svim/share/vim/vim91/pack/dist/opt/cfilter
set runtimepath+=/nix/store/hzv94c2j54lsg4qv9b47szn2jqmzcixr-svim/share/vim/vimfiles/after
set runtimepath+=~/.vim/plugged/vim-signature/after
set runtimepath+=~/.vim/plugged/tabular/after
set runtimepath+=~/.vim/plugged/cmake4vim/after
set runtimepath+=~/.vim/plugged/vim-matchup/after
set runtimepath+=~/.vim/plugged/vim-textobj-markdown/after
set runtimepath+=~/.vim/plugged/vim-pythonsense/after
set runtimepath+=~/.vim/plugged/haskell-vim/after
set runtimepath+=~/.vim/plugged/vim-markdown/after
set runtimepath+=~/.vim/plugged/vim-css-color/after
set runtimepath+=~/.vim/plugged/vim-cpp-modern/after
set runtimepath+=~/.vim/after
set scrolloff=4
set secure
set noshelltemp
set shiftwidth=4
set shortmess=atsOF
set showbreak=\\>\ 
set showcmd
set showmatch
set smartcase
set smarttab
set softtabstop=4
set splitbelow
set splitkeep=screen
set splitright
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set switchbuf=usetab,useopen
set synmaxcol=250
set termencoding=utf-8
set termguicolors
set notimeout
set ttimeout
set ttimeoutlen=100
set undodir=~/.vim/history
set undofile
set undolevels=10000
set updatetime=50
set wildignore=*.o,*.elf,*.bin,*.dll,*.so,.git/**,.local/**,.?cache/**,git*/**,build/**,*.o,*.obj,*.swp,*.so,*.a,*.bin,*.pdf,*.djvu,*.epub,*.opus,*.ogg,*.mp3,*.mp4,*.mkv,*.webm,*.AppImage,*.exe,*.lock,*~,*.doc,*.xls,.?git*,*.hi,*.cma,*.cmi
set wildmode=list:longest,full
set wildoptions=fuzzy,tagfile,pum
set wrapmargin=1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/gits/studia/zadanka/rozprochy/zookeeper
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +18 zkServer2.cmd
badd +0 conf/zoo.cfg
badd +1 conf/configuration.xsl
badd +0 conf/logback.xml
argglobal
%argdel
$argadd zkServer2.cmd
$argadd conf/zoo.cfg
set stal=2
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit conf/zoo.cfg
argglobal
2argu
balt zkServer2.cmd
let s:cpo_save=&cpo
set cpo&vim
inoremap <buffer> <expr> <Plug>L2UTab LaTeXtoUnicode#Tab()
cnoremap <buffer> <expr> <S-Tab> LaTeXtoUnicode#CmdTab(128)
inoremap <buffer> <silent> <M-n> :call AutoPairsJump()a
inoremap <buffer> <silent> <expr> <C-X>= AutoPairsToggle()
inoremap <buffer> <silent> <M-b> =AutoPairsBackInsert()
inoremap <buffer> <silent> <M-e> =AutoPairsFastWrap()
inoremap <buffer> <silent> <C-H> =AutoPairsDelete()
inoremap <buffer> <silent> <BS> =AutoPairsDelete()
inoremap <buffer> <silent> <M-'> =AutoPairsMoveCharacter('''')
inoremap <buffer> <silent> <M-"> =AutoPairsMoveCharacter('"')
inoremap <buffer> <silent> <M-}> =AutoPairsMoveCharacter('}')
inoremap <buffer> <silent> <M-{> =AutoPairsMoveCharacter('{')
inoremap <buffer> <silent> <M-]> =AutoPairsMoveCharacter(']')
inoremap <buffer> <silent> <M-[> =AutoPairsMoveCharacter('[')
inoremap <buffer> <silent> <M-)> =AutoPairsMoveCharacter(')')
inoremap <buffer> <silent> <M-(> =AutoPairsMoveCharacter('(')
noremap <buffer> <silent> = :call AutoPairsToggle()
inoremap <buffer> <expr> L2UFallbackTab pumvisible() ? "" : "	"
inoremap <buffer> <silent> § =AutoPairsMoveCharacter('''')
inoremap <buffer> <silent> ¢ =AutoPairsMoveCharacter('"')
inoremap <buffer> <silent> © =AutoPairsMoveCharacter(')')
inoremap <buffer> <silent> ¨ =AutoPairsMoveCharacter('(')
inoremap <buffer> <silent> î :call AutoPairsJump()a
inoremap <buffer> <silent> â =AutoPairsBackInsert()
inoremap <buffer> <silent> å =AutoPairsFastWrap()
inoremap <buffer> <silent> ý =AutoPairsMoveCharacter('}')
inoremap <buffer> <silent> û =AutoPairsMoveCharacter('{')
inoremap <buffer> <silent> Ý =AutoPairsMoveCharacter(']')
inoremap <buffer> <silent> Û =AutoPairsMoveCharacter('[')
noremap <buffer> <silent> <M-n> :call AutoPairsJump()
noremap <buffer> <silent> <C-X>= :call AutoPairsToggle()
inoremap <buffer> <silent>  =AutoPairsDelete()
imap <buffer> 	 <Plug>L2UTab
cnoremap <buffer> <expr> 	 LaTeXtoUnicode#CmdTab(9)
inoremap <buffer> <silent> <expr> = AutoPairsToggle()
inoremap <buffer> <silent>   =AutoPairsSpace()
inoremap <buffer> <silent> " =AutoPairsInsert('"')
inoremap <buffer> <silent> ' =AutoPairsInsert('''')
inoremap <buffer> <silent> ( =AutoPairsInsert('(')
inoremap <buffer> <silent> ) =AutoPairsInsert(')')
noremap <buffer> <silent> î :call AutoPairsJump()
inoremap <buffer> <silent> [ =AutoPairsInsert('[')
inoremap <buffer> <silent> ] =AutoPairsInsert(']')
inoremap <buffer> <silent> ` =AutoPairsInsert('`')
inoremap <buffer> <silent> { =AutoPairsInsert('{')
inoremap <buffer> <silent> } =AutoPairsInsert('}')
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal autoindent
setlocal backupcopy=
setlocal nobinary
set breakindent
setlocal breakindent
set breakindentopt=shift:2,min:40,sbr
setlocal breakindentopt=shift:2,min:40,sbr
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinscopedecls=public,protected,private
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=#\ %s
setlocal complete=w,b,s,i,d,.,k
setlocal completefunc=LaTeXtoUnicode#completefunc
setlocal completeopt=
setlocal concealcursor=
set conceallevel=2
setlocal conceallevel=2
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
set cursorline
setlocal cursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal eventignorewin=
setlocal expandtab
if &filetype != 'cfg'
setlocal filetype=cfg
endif
setlocal fillchars=
setlocal findfunc=
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
set foldmarker=\ {{{,\ }}}
setlocal foldmarker=\ {{{,\ }}}
set foldmethod=marker
setlocal foldmethod=marker
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatoptions=wncroql
setlocal formatprg=
setlocal grepformat=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal isexpand=
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal lhistory=10
set linebreak
setlocal linebreak
setlocal nolisp
setlocal lispoptions=
setlocal lispwords=
setlocal nolist
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal nomodeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=syntaxcomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
set relativenumber
setlocal relativenumber
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal nosmoothscroll
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=250
if &syntax != 'cfg'
setlocal syntax=cfg
endif
setlocal tabstop=8
setlocal tagcase=
setlocal tagfunc=
setlocal tags=~/.cache/vim/ctags//home-michal-gits-studia-zadanka-rozprochy-zookeeper-tags,./tags,tags
setlocal textwidth=0
setlocal thesaurus=
setlocal thesaurusfunc=
setlocal undofile
setlocal undolevels=-123456
setlocal virtualedit=
setlocal wincolor=
setlocal nowinfixbuf
setlocal nowinfixheight
setlocal nowinfixwidth
set nowrap
setlocal nowrap
setlocal wrapmargin=1
let s:l = 38 - ((37 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 38
normal! 010|
lcd ~/gits/studia/zadanka/rozprochy/zookeeper/conf
tabnext
edit ~/gits/studia/zadanka/rozprochy/zookeeper/conf/logback.xml
arglocal
%argdel
$argadd ~/gits/studia/zadanka/rozprochy/zookeeper/conf/configuration.xsl
$argadd ~/gits/studia/zadanka/rozprochy/zookeeper/conf/logback.xml
balt ~/gits/studia/zadanka/rozprochy/zookeeper/conf/configuration.xsl
let s:cpo_save=&cpo
set cpo&vim
inoremap <buffer> <silent> <M-n> :call AutoPairsJump()a
inoremap <buffer> <silent> <expr> <C-X>= AutoPairsToggle()
inoremap <buffer> <silent> <M-b> =AutoPairsBackInsert()
inoremap <buffer> <silent> <M-e> =AutoPairsFastWrap()
inoremap <buffer> <silent> <C-H> =AutoPairsDelete()
inoremap <buffer> <silent> <BS> =AutoPairsDelete()
inoremap <buffer> <silent> <M-'> =AutoPairsMoveCharacter('''')
inoremap <buffer> <silent> <M-"> =AutoPairsMoveCharacter('"')
inoremap <buffer> <silent> <M-}> =AutoPairsMoveCharacter('}')
inoremap <buffer> <silent> <M-{> =AutoPairsMoveCharacter('{')
inoremap <buffer> <silent> <M-]> =AutoPairsMoveCharacter(']')
inoremap <buffer> <silent> <M-[> =AutoPairsMoveCharacter('[')
inoremap <buffer> <silent> <M-)> =AutoPairsMoveCharacter(')')
inoremap <buffer> <silent> <M-(> =AutoPairsMoveCharacter('(')
inoremap <buffer> <expr> <Plug>L2UTab LaTeXtoUnicode#Tab()
cnoremap <buffer> <expr> <S-Tab> LaTeXtoUnicode#CmdTab(128)
noremap <buffer> <silent> = :call AutoPairsToggle()
nnoremap <buffer> <silent> A :call tagalong#Trigger("A", v:count)
inoremap <buffer> <silent> § =AutoPairsMoveCharacter('''')
inoremap <buffer> <silent> ¢ =AutoPairsMoveCharacter('"')
inoremap <buffer> <silent> © =AutoPairsMoveCharacter(')')
inoremap <buffer> <silent> ¨ =AutoPairsMoveCharacter('(')
inoremap <buffer> <expr> L2UFallbackTab pumvisible() ? "" : "	"
inoremap <buffer> <silent> î :call AutoPairsJump()a
inoremap <buffer> <silent> â =AutoPairsBackInsert()
inoremap <buffer> <silent> å =AutoPairsFastWrap()
inoremap <buffer> <silent> ý =AutoPairsMoveCharacter('}')
inoremap <buffer> <silent> û =AutoPairsMoveCharacter('{')
inoremap <buffer> <silent> Ý =AutoPairsMoveCharacter(']')
inoremap <buffer> <silent> Û =AutoPairsMoveCharacter('[')
nnoremap <buffer> <silent> C :call tagalong#Trigger("C", v:count)
nnoremap <buffer> <silent> a :call tagalong#Trigger("a", v:count)
nnoremap <buffer> <silent> c :call tagalong#Trigger("c", v:count)
nnoremap <buffer> <silent> i :call tagalong#Trigger("i", v:count)
nnoremap <buffer> <silent> v :call tagalong#Trigger("v", v:count)
noremap <buffer> <silent> <M-n> :call AutoPairsJump()
noremap <buffer> <silent> <C-X>= :call AutoPairsToggle()
inoremap <buffer> <silent>  =AutoPairsDelete()
imap <buffer> 	 <Plug>L2UTab
cnoremap <buffer> <expr> 	 LaTeXtoUnicode#CmdTab(9)
inoremap <buffer> <silent> <expr> = AutoPairsToggle()
inoremap <buffer> <silent>   =AutoPairsSpace()
inoremap <buffer> <silent> " =AutoPairsInsert('"')
inoremap <buffer> <silent> ' =AutoPairsInsert('''')
inoremap <buffer> <silent> ( =AutoPairsInsert('(')
inoremap <buffer> <silent> ) =AutoPairsInsert(')')
noremap <buffer> <silent> î :call AutoPairsJump()
inoremap <buffer> <silent> [ =AutoPairsInsert('[')
inoremap <buffer> <silent> ] =AutoPairsInsert(']')
inoremap <buffer> <silent> ` =AutoPairsInsert('`')
inoremap <buffer> <silent> { =AutoPairsInsert('{')
inoremap <buffer> <silent> } =AutoPairsInsert('}')
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal autoindent
setlocal backupcopy=
setlocal nobinary
set breakindent
setlocal breakindent
set breakindentopt=shift:2,min:40,sbr
setlocal breakindentopt=shift:2,min:40,sbr
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinscopedecls=public,protected,private
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s:<!--,e:-->
setlocal commentstring=<!--\ %s\ -->
setlocal complete=w,b,s,i,d,.,k
setlocal completefunc=LaTeXtoUnicode#completefunc
setlocal completeopt=
setlocal concealcursor=
set conceallevel=2
setlocal conceallevel=2
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
set cursorline
setlocal cursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal eventignorewin=
setlocal expandtab
if &filetype != 'xml'
setlocal filetype=xml
endif
setlocal fillchars=
setlocal findfunc=
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
set foldmarker=\ {{{,\ }}}
setlocal foldmarker=\ {{{,\ }}}
set foldmethod=marker
setlocal foldmethod=marker
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=xmlformat#Format()
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatoptions=wncroql
setlocal formatprg=
setlocal grepformat=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=XmlIndentGet(v:lnum,1)
setlocal indentkeys=o,O,*<Return>,<>>,<<>,/,{,},!^F
setlocal noinfercase
setlocal isexpand=
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal lhistory=10
set linebreak
setlocal linebreak
setlocal nolisp
setlocal lispoptions=
setlocal lispwords=
setlocal nolist
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal nomodeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=xmlcomplete#CompleteTags
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
set relativenumber
setlocal relativenumber
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal nosmoothscroll
setlocal softtabstop=4
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=
setlocal swapfile
setlocal synmaxcol=250
if &syntax != 'xml'
setlocal syntax=xml
endif
setlocal tabstop=8
setlocal tagcase=
setlocal tagfunc=
setlocal tags=~/.cache/vim/ctags//home-michal-gits-studia-zadanka-rozprochy-zookeeper-tags,./tags,tags
setlocal textwidth=0
setlocal thesaurus=
setlocal thesaurusfunc=
setlocal undofile
setlocal undolevels=-123456
setlocal virtualedit=
setlocal wincolor=
setlocal nowinfixbuf
setlocal nowinfixheight
setlocal nowinfixwidth
set nowrap
setlocal nowrap
setlocal wrapmargin=1
let s:l = 1 - ((0 * winheight(0) + 22) / 45)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/gits/studia/zadanka/rozprochy/zookeeper/conf
tabnext 2
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
set shortmess=atsOF
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
