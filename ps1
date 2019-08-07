ZSHMISC(1)                                            General Commands Manual                                            ZSHMISC(1)

NNAAMMEE
       zshmisc - everything and then some

SSIIMMPPLLEE CCOOMMMMAANNDDSS && PPIIPPEELLIINNEESS
       A  _s_i_m_p_l_e  _c_o_m_m_a_n_d is a sequence of optional parameter assignments followed by blank-separated words, with optional redirec‐
       tions interspersed.  For a description of assignment, see the beginning of _z_s_h_p_a_r_a_m(1).

       The first word is the command to be executed, and the remaining words, if any, are arguments to the command.  If  a  command
       name  is  given, the parameter assignments modify the environment of the command when it is executed.  The value of a simple
       command is its exit status, or 128 plus the signal number if terminated by a signal.  For example,

              eecchhoo ffoooo

       is a simple command with arguments.

       A _p_i_p_e_l_i_n_e is either a simple command, or a sequence of two or more simple commands where each command is separated from the
       next  by  `||'  or  `||&&'.   Where commands are separated by `||', the standard output of the first command is connected to the
       standard input of the next.  `||&&' is shorthand for `22>>&&11 ||', which connects both the standard output and the standard  error
       of  the  command  to  the  standard input of the next.  The value of a pipeline is the value of the last command, unless the
       pipeline is preceded by `!!' in which case the value is the logical inverse of the value of the last command.  For example,

              eecchhoo ffoooo || sseedd ''ss//ffoooo//bbaarr//''

       is a pipeline, where the output (`ffoooo' plus a newline) of the first command will be passed to the input of the second.

       If a pipeline is preceded by `ccoopprroocc', it is executed as a coprocess; a two-way pipe is established between it and the  par‐
       ent  shell.  The shell can read from or write to the coprocess by means of the `>>&&pp' and `<<&&pp' redirection operators or with
       `pprriinntt --pp' and `rreeaadd --pp'.  A pipeline cannot be preceded by both `ccoopprroocc' and `!!'.  If job control is active, the  coprocess
       can be treated in other than input and output as an ordinary background job.

       A  _s_u_b_l_i_s_t  is either a single pipeline, or a sequence of two or more pipelines separated by `&&&&' or `||||'.  If two pipelines
       are separated by `&&&&', the second pipeline is executed only if the first succeeds (returns a zero status).  If two pipelines
       are separated by `||||', the second is executed only if the first fails (returns a nonzero status).  Both operators have equal
       precedence and are left associative.  The value of the sublist is the value of the last pipeline executed.  For example,

              ddmmeessgg || ggrreepp ppaanniicc &&&& pprriinntt yyeess

       is a sublist consisting of two pipelines, the second just a simple command which will be executed if and only  if  the  ggrreepp
       command  returns  a  zero  status.   If  it  does not, the value of the sublist is that return status, else it is the status
       returned by the pprriinntt (almost certainly zero).

       A _l_i_s_t is a sequence of zero or more sublists, in which each sublist is terminated by `;;', `&&', `&&||', `&&!!',  or  a  newline.
       This  terminator  may  optionally  be  omitted  from the last sublist in the list when the list appears as a complex command
       inside `((...))' or `{{...}}'.  When a sublist is terminated by `;;' or newline, the shell waits for it to finish before  execut‐
       ing the next sublist.  If a sublist is terminated by a `&&', `&&||', or `&&!!', the shell executes the last pipeline in it in the
       background, and does not wait for it to finish (note the difference from other shells which execute the whole sublist in the
       background).  A backgrounded pipeline returns a status of zero.

       More  generally, a list can be seen as a set of any shell commands whatsoever, including the complex commands below; this is
       implied wherever the word `list' appears in later descriptions.  For example, the commands in a shell function form  a  spe‐
       cial sort of list.

PPRREECCOOMMMMAANNDD MMOODDIIFFIIEERRSS
       A simple command may be preceded by a _p_r_e_c_o_m_m_a_n_d _m_o_d_i_f_i_e_r, which will alter how the command is interpreted.  These modifiers
       are shell builtin commands with the exception of nnooccoorrrreecctt which is a reserved word.

       --      The command is executed with a `--' prepended to its aarrggvv[[00]] string.

       bbuuiillttiinn
              The command word is taken to be the name of a builtin command, rather than a shell function or external command.

       ccoommmmaanndd [ --ppvvVV ]
              The command word is taken to be the name of an external command, rather than a shell function or  builtin.    If  the
              PPOOSSIIXX__BBUUIILLTTIINNSS  option  is set, builtins will also be executed but certain special properties of them are suppressed.
              The --pp flag causes a default path to be searched instead of that in $$ppaatthh. With the --vv flag, ccoommmmaanndd  is  similar  to
              wwhheennccee and with --VV, it is equivalent to wwhheennccee --vv.

       eexxeecc [ --ccll ] [ --aa _a_r_g_v_0 ]
              The  following  command  together  with  any  arguments  is  run  in  place  of the current process, rather than as a
              sub-process.  The shell does not fork and is replaced.  The shell does not invoke TTRRAAPPEEXXIITT, nor does it  source  zzlloo‐‐
              ggoouutt files.  The options are provided for compatibility with other shells.

              The --cc option clears the environment.

              The --ll option is equivalent to the -- precommand modifier, to treat the replacement command as a login shell; the com‐
              mand is executed with a -- prepended to its aarrggvv[[00]] string.  This flag has no effect if  used  together  with  the  --aa
              option.

              The  --aa  option  is  used  to  specify  explicitly the aarrggvv[[00]] string (the name of the command as seen by the process
              itself) to be used by the replacement command and is directly equivalent to setting a value for the AARRGGVV00 environment
              variable.

       nnooccoorrrreecctt
              Spelling correction is not done on any of the words.  This must appear before any other precommand modifier, as it is
              interpreted immediately, before any parsing is done.  It has no effect in non-interactive shells.

       nnoogglloobb Filename generation (globbing) is not performed on any of the words.

CCOOMMPPLLEEXX CCOOMMMMAANNDDSS
       A _c_o_m_p_l_e_x _c_o_m_m_a_n_d in zsh is one of the following:

       iiff _l_i_s_t tthheenn _l_i_s_t [ eelliiff _l_i_s_t tthheenn _l_i_s_t ] ... [ eellssee _l_i_s_t ] ffii
              The iiff _l_i_s_t is executed, and if it returns a zero exit status, the tthheenn _l_i_s_t is executed.  Otherwise, the  eelliiff  _l_i_s_t
              is executed and if its status is zero, the tthheenn _l_i_s_t is executed.  If each eelliiff _l_i_s_t returns nonzero status, the eellssee
              _l_i_s_t is executed.

       ffoorr _n_a_m_e ... [ iinn _w_o_r_d ... ] _t_e_r_m ddoo _l_i_s_t ddoonnee
              where _t_e_r_m is at least one newline or ;;.  Expand the list of _w_o_r_ds, and set the parameter _n_a_m_e to  each  of  them  in
              turn, executing _l_i_s_t each time.  If the iinn _w_o_r_d is omitted, use the positional parameters instead of the _w_o_r_ds.

              More  than  one  parameter _n_a_m_e can appear before the list of _w_o_r_ds.  If _N _n_a_m_es are given, then on each execution of
              the loop the next _N _w_o_r_ds are assigned to the corresponding parameters.  If  there  are  more  _n_a_m_es  than  remaining
              _w_o_r_ds,  the  remaining  parameters  are  each  set  to the empty string.  Execution of the loop ends when there is no
              remaining _w_o_r_d to assign to the first _n_a_m_e.  It is only possible for iinn to appear as the first _n_a_m_e in the list, else
              it will be treated as marking the end of the list.

       ffoorr (((( [_e_x_p_r_1] ;; [_e_x_p_r_2] ;; [_e_x_p_r_3] )))) ddoo _l_i_s_t ddoonnee
              The arithmetic expression _e_x_p_r_1 is evaluated first (see the section `Arithmetic Evaluation').  The arithmetic expres‐
              sion _e_x_p_r_2 is repeatedly evaluated until it evaluates to zero and when non-zero, _l_i_s_t is executed and the  arithmetic
              expression _e_x_p_r_3 evaluated.  If any expression is omitted, then it behaves as if it evaluated to 1.

       wwhhiillee _l_i_s_t ddoo _l_i_s_t ddoonnee
              Execute the ddoo _l_i_s_t as long as the wwhhiillee _l_i_s_t returns a zero exit status.

       uunnttiill _l_i_s_t ddoo _l_i_s_t ddoonnee
              Execute the ddoo _l_i_s_t as long as uunnttiill _l_i_s_t returns a nonzero exit status.

       rreeppeeaatt _w_o_r_d ddoo _l_i_s_t ddoonnee
              _w_o_r_d is expanded and treated as an arithmetic expression, which must evaluate to a number _n.  _l_i_s_t is then executed _n
              times.

              The rreeppeeaatt syntax is disabled by default when the shell starts in a mode emulating another shell.  It can be  enabled
              with the command `eennaabbllee --rr rreeppeeaatt'

       ccaassee _w_o_r_d iinn [ [((] _p_a_t_t_e_r_n [ || _p_a_t_t_e_r_n ] ... )) _l_i_s_t (;;;;|;;&&|;;||) ] ... eessaacc
              Execute  the  _l_i_s_t associated with the first _p_a_t_t_e_r_n that matches _w_o_r_d, if any.  The form of the patterns is the same
              as that used for filename generation.  See the section `Filename Generation'.

              Note further that, unless the SSHH__GGLLOOBB option is set, the whole pattern with alternatives is treated by the  shell  as
              equivalent  to  a group of patterns within parentheses, although white space may appear about the parentheses and the
              vertical bar and will be stripped from the pattern at those points.  White space may appear elsewhere in the pattern;
              this  is  not stripped.  If the SSHH__GGLLOOBB option is set, so that an opening parenthesis can be unambiguously treated as
              part of the case syntax, the expression is parsed into separate words and these are treated  as  strict  alternatives
              (as in other shells).

              If the _l_i_s_t that is executed is terminated with ;;&& rather than ;;;;, the following list is also executed.  The rule for
              the terminator of the following list ;;;;, ;;&& or ;;|| is applied unless the eessaacc is reached.

              If the _l_i_s_t that is executed is terminated with ;;|| the shell continues to scan the  _p_a_t_t_e_r_ns  looking  for  the  next
              match,  executing  the corresponding _l_i_s_t, and applying the rule for the corresponding terminator ;;;;, ;;&& or ;;||.  Note
              that _w_o_r_d is not re-expanded; all applicable _p_a_t_t_e_r_ns are tested with the same _w_o_r_d.

       sseelleecctt _n_a_m_e [ iinn _w_o_r_d ... _t_e_r_m ] ddoo _l_i_s_t ddoonnee
              where _t_e_r_m is one or more newline or ;; to terminate the _w_o_r_ds.  Print the set of _w_o_r_ds, each preceded  by  a  number.
              If  the iinn _w_o_r_d is omitted, use the positional parameters.  The PPRROOMMPPTT33 prompt is printed and a line is read from the
              line editor if the shell is interactive and that is active, or else standard input.  If this  line  consists  of  the
              number  of one of the listed _w_o_r_ds, then the parameter _n_a_m_e is set to the _w_o_r_d corresponding to this number.  If this
              line is empty, the selection list is printed again.  Otherwise, the value of the parameter _n_a_m_e is set to null.   The
              contents  of  the line read from standard input is saved in the parameter RREEPPLLYY.  _l_i_s_t is executed for each selection
              until a break or end-of-file is encountered.

       (( _l_i_s_t ))
              Execute _l_i_s_t in a subshell.  Traps set by the ttrraapp builtin are reset to their default values while executing _l_i_s_t.

       {{ _l_i_s_t }}
              Execute _l_i_s_t.

       {{ _t_r_y_-_l_i_s_t }} aallwwaayyss {{ _a_l_w_a_y_s_-_l_i_s_t }}
              First execute _t_r_y_-_l_i_s_t.  Regardless of errors, or bbrreeaakk, ccoonnttiinnuuee, or rreettuurrnn commands  encountered  within  _t_r_y_-_l_i_s_t,
              execute  _a_l_w_a_y_s_-_l_i_s_t.   Execution  then  continues  from the result of the execution of _t_r_y_-_l_i_s_t; in other words, any
              error, or bbrreeaakk, ccoonnttiinnuuee, or rreettuurrnn command is treated in the normal way, as if _a_l_w_a_y_s_-_l_i_s_t were not  present.   The
              two chunks of code are referred to as the `try block' and the `always block'.

              Optional newlines or semicolons may appear after the aallwwaayyss; note, however, that they may _n_o_t appear between the pre‐
              ceding closing brace and the aallwwaayyss.

              An `error' in this context is a condition such as a syntax error which causes the shell to  abort  execution  of  the
              current  function,  script,  or list.  Syntax errors encountered while the shell is parsing the code do not cause the
              _a_l_w_a_y_s_-_l_i_s_t to be executed.  For example, an erroneously constructed iiff block in ttrryy--lliisstt would cause  the  shell  to
              abort  during  parsing,  so  that aallwwaayyss--lliisstt would not be executed, while an erroneous substitution such as $${{**ffoooo**}}
              would cause a run-time error, after which aallwwaayyss--lliisstt would be executed.

              An error condition can be tested and reset with the special integer variable TTRRYY__BBLLOOCCKK__EERRRROORR.  Outside an aallwwaayyss--lliisstt
              the value is irrelevant, but it is initialised to --11.  Inside aallwwaayyss--lliisstt, the value is 1 if an error occurred in the
              ttrryy--lliisstt, else 0.  If TTRRYY__BBLLOOCCKK__EERRRROORR is set to 0 during the aallwwaayyss--lliisstt, the error condition caused by the  ttrryy--lliisstt
              is  reset,  and  shell  execution  continues  normally  after  the end of aallwwaayyss--lliisstt.  Altering the value during the
              ttrryy--lliisstt is not useful (unless this forms part of an enclosing aallwwaayyss block).

              Regardless of TTRRYY__BBLLOOCCKK__EERRRROORR, after the end of aallwwaayyss--lliisstt the normal shell status $$?? is  the  value  returned  from
              ttrryy--lliisstt.  This will be non-zero if there was an error, even if TTRRYY__BBLLOOCCKK__EERRRROORR was set to zero.

              The following executes the given code, ignoring any errors it causes.  This is an alternative to the usual convention
              of protecting code by executing it in a subshell.

                     {{
                         ## ccooddee wwhhiicchh mmaayy ccaauussee aann eerrrroorr
                       }} aallwwaayyss {{
                         ## TThhiiss ccooddee iiss eexxeeccuutteedd rreeggaarrddlleessss ooff tthhee eerrrroorr..
                         (((( TTRRYY__BBLLOOCCKK__EERRRROORR == 00 ))))
                     }}
                     ## TThhee eerrrroorr ccoonnddiittiioonn hhaass bbeeeenn rreesseett..

              An eexxiitt command (or a rreettuurrnn command executed at the outermost function level of a script)  encountered  in  ttrryy--lliisstt
              does  _n_o_t cause the execution of _a_l_w_a_y_s_-_l_i_s_t.  Instead, the shell exits immediately after any EEXXIITT trap has been exe‐
              cuted.

       ffuunnccttiioonn _w_o_r_d ... [ (()) ] [ _t_e_r_m ] {{ _l_i_s_t }}
       _w_o_r_d ... (()) [ _t_e_r_m ] {{ _l_i_s_t }}
       _w_o_r_d ... (()) [ _t_e_r_m ] _c_o_m_m_a_n_d
              where _t_e_r_m is one or more newline or ;;.  Define a function which is referenced by any one of  _w_o_r_d.   Normally,  only
              one _w_o_r_d is provided; multiple _w_o_r_ds are usually only useful for setting traps.  The body of the function is the _l_i_s_t
              between the {{ and }}.  See the section `Functions'.

              If the option SSHH__GGLLOOBB is set for compatibility with other shells, then whitespace may appear  between  the  left  and
              right parentheses when there is a single _w_o_r_d;  otherwise, the parentheses will be treated as forming a globbing pat‐
              tern in that case.

              In any of the forms above, a redirection may appear outside the function body, for example

                     ffuunncc(()) {{ ...... }} 22>>&&11

              The redirection is stored with the function and applied whenever the function is executed.  Any variables in the  re‐
              direction are expanded at the point the function is executed, but outside the function scope.

       ttiimmee [ _p_i_p_e_l_i_n_e ]
              The  _p_i_p_e_l_i_n_e  is  executed,  and  timing  statistics are reported on the standard error in the form specified by the
              TTIIMMEEFFMMTT parameter.  If _p_i_p_e_l_i_n_e is omitted, print statistics about the shell process and its children.

       [[[[ _e_x_p ]]]]
              Evaluates the conditional expression _e_x_p and return a zero exit status if it is true.  See the  section  `Conditional
              Expressions' for a description of _e_x_p.

AALLTTEERRNNAATTEE FFOORRMMSS FFOORR CCOOMMPPLLEEXX CCOOMMMMAANNDDSS
       Many  of  zsh's complex commands have alternate forms.  These are non-standard and are likely not to be obvious even to sea‐
       soned shell programmers; they should not be used anywhere that portability of shell code is a concern.

       The short versions below only work if _s_u_b_l_i_s_t is of the form `{{ _l_i_s_t }}' or if the SSHHOORRTT__LLOOOOPPSS option is set.   For  the  iiff,
       wwhhiillee  and uunnttiill commands, in both these cases the test part of the loop must also be suitably delimited, such as by `[[[[ _._._.
       ]]]]' or `(((( _._._. ))))', else the end of the test will not be recognized.  For the ffoorr, rreeppeeaatt, ccaassee and sseelleecctt commands no  such
       special  form for the arguments is necessary, but the other condition (the special form of _s_u_b_l_i_s_t or use of the SSHHOORRTT__LLOOOOPPSS
       option) still applies.

       iiff _l_i_s_t {{ _l_i_s_t }} [ eelliiff _l_i_s_t {{ _l_i_s_t }} ] ... [ eellssee {{ _l_i_s_t }} ]
              An alternate form of iiff.  The rules mean that

                     iiff [[[[ --oo iiggnnoorreebbrraacceess ]]]] {{
                       pprriinntt yyeess
                     }}

              works, but

                     iiff ttrruuee {{  ## DDooeess nnoott wwoorrkk!!
                       pprriinntt yyeess
                     }}

              does _n_o_t, since the test is not suitably delimited.

       iiff _l_i_s_t _s_u_b_l_i_s_t
              A short form of the alternate iiff.  The same limitations on the form of _l_i_s_t apply as for the previous form.

       ffoorr _n_a_m_e ... (( _w_o_r_d ... )) _s_u_b_l_i_s_t
              A short form of ffoorr.

       ffoorr _n_a_m_e ... [ iinn _w_o_r_d ... ] _t_e_r_m _s_u_b_l_i_s_t
              where _t_e_r_m is at least one newline or ;;.  Another short form of ffoorr.

       ffoorr (((( [_e_x_p_r_1] ;; [_e_x_p_r_2] ;; [_e_x_p_r_3] )))) _s_u_b_l_i_s_t
              A short form of the arithmetic ffoorr command.

       ffoorreeaacchh _n_a_m_e ... (( _w_o_r_d ... )) _l_i_s_t eenndd
              Another form of ffoorr.

       wwhhiillee _l_i_s_t {{ _l_i_s_t }}
              An alternative form of wwhhiillee.  Note the limitations on the form of _l_i_s_t mentioned above.

       uunnttiill _l_i_s_t {{ _l_i_s_t }}
              An alternative form of uunnttiill.  Note the limitations on the form of _l_i_s_t mentioned above.

       rreeppeeaatt _w_o_r_d _s_u_b_l_i_s_t
              This is a short form of rreeppeeaatt.

       ccaassee _w_o_r_d {{ [ [((] _p_a_t_t_e_r_n [ || _p_a_t_t_e_r_n ] ... )) _l_i_s_t (;;;;|;;&&|;;||) ] ... }}
              An alternative form of ccaassee.

       sseelleecctt _n_a_m_e [ iinn _w_o_r_d ... _t_e_r_m ] _s_u_b_l_i_s_t
              where _t_e_r_m is at least one newline or ;;.  A short form of sseelleecctt.

       ffuunnccttiioonn _w_o_r_d ... [ (()) ] [ _t_e_r_m ] _s_u_b_l_i_s_t
              This is a short form of ffuunnccttiioonn.

RREESSEERRVVEEDD WWOORRDDSS
       The following words are recognized as reserved words when used as the first word of a  command  unless  quoted  or  disabled
       using ddiissaabbllee --rr:

       ddoo  ddoonnee  eessaacc  tthheenn  eelliiff eellssee ffii ffoorr ccaassee iiff wwhhiillee ffuunnccttiioonn rreeppeeaatt ttiimmee uunnttiill sseelleecctt ccoopprroocc nnooccoorrrreecctt ffoorreeaacchh eenndd !! [[[[ {{ }}
       ddeeccllaarree eexxppoorrtt ffllooaatt iinntteeggeerr llooccaall rreeaaddoonnllyy ttyyppeesseett

       Additionally, `}}' is recognized in any position if neither the IIGGNNOORREE__BBRRAACCEESS option nor the  IIGGNNOORREE__CCLLOOSSEE__BBRRAACCEESS  option  is
       set.

EERRRROORRSS
       Certain errors are treated as fatal by the shell: in an interactive shell, they cause control to return to the command line,
       and in a non-interactive shell they cause the shell to be aborted.  In older versions of zsh, a non-interactive  shell  run‐
       ning  a  script would not abort completely, but would resume execution at the next command to be read from the script, skip‐
       ping the remainder of any functions or shell constructs such as loops or conditions; this somewhat illogical  behaviour  can
       be recovered by setting the option CCOONNTTIINNUUEE__OONN__EERRRROORR.

       Fatal errors found in non-interactive shells include:

       ·      Failure to parse shell options passed when invoking the shell

       ·      Failure to change options with the sseett builtin

       ·      Parse errors of all sorts, including failures to parse mathematical expressions

       ·      Failures to set or modify variable behaviour with ttyyppeesseett, llooccaall, ddeeccllaarree, eexxppoorrtt, iinntteeggeerr, ffllooaatt

       ·      Execution of incorrectly positioned loop control structures (ccoonnttiinnuuee, bbrreeaakk)

       ·      Attempts to use regular expression with no regular expression module available

       ·      Disallowed operations when the RREESSTTRRIICCTTEEDD options is set

       ·      Failure to create a pipe needed for a pipeline

       ·      Failure to create a multio

       ·      Failure to autoload a module needed for a declared shell feature

       ·      Errors creating command or process substitutions

       ·      Syntax errors in glob qualifiers

       ·      File generation errors where not caught by the option BBAADD__PPAATTTTEERRNN

       ·      All bad patterns used for matching within case statements

       ·      File generation failures where not caused by NNOO__MMAATTCCHH or similar options

       ·      All file generation errors where the pattern was used to create a multio

       ·      Memory errors where detected by the shell

       ·      Invalid subscripts to shell variables

       ·      Attempts to assign read-only variables

       ·      Logical errors with variables such as assignment to the wrong type

       ·      Use of invalid variable names

       ·      Errors in variable substitution syntax

       ·      Failure to convert characters in $$''...'' expressions

       If  the  PPOOSSIIXX__BBUUIILLTTIINNSS option is set, more errors associated with shell builtin commands are treated as fatal, as specified
       by the POSIX standard.

CCOOMMMMEENNTTSS
       In non-interactive shells, or in interactive shells with the IINNTTEERRAACCTTIIVVEE__CCOOMMMMEENNTTSS option set,  a  word  beginning  with  the
       third  character  of the hhiissttcchhaarrss parameter (`##' by default) causes that word and all the following characters up to a new‐
       line to be ignored.

AALLIIAASSIINNGG
       Every eligible _w_o_r_d in the shell input is checked to see if there is an alias defined for it.  If so, it is replaced by  the
       text  of  the  alias  if  it  is in command position (if it could be the first word of a simple command), or if the alias is
       global.  If the replacement text ends with a space, the next word in the shell input is  always  eligible  for  purposes  of
       alias  expansion.   An  alias  is defined using the aalliiaass builtin; global aliases may be defined using the --gg option to that
       builtin.

       A _w_o_r_d is defined as:

       ·      Any plain string or glob pattern

       ·      Any quoted string, using any quoting method (note that the quotes must be part of the alias definition for this to be
              eligible)

       ·      Any parameter reference or command substitution

       ·      Any series of the foregoing, concatenated without whitespace or other tokens between them

       ·      Any reserved word (ccaassee, ddoo, eellssee, etc.)

       ·      With global aliasing, any command separator, any redirection operator, and `((' or `))' when not part of a glob pattern

       It  is not presently possible to alias the `((((' token that introduces arithmetic expressions, because until a full statement
       has been parsed, it cannot be distinguished from two consecutive `((' tokens introducing nested subshells.

       When PPOOSSIIXX__AALLIIAASSEESS is set, only plain unquoted strings are eligible for aliasing.  The aalliiaass builtin does not reject  ineli‐
       gible aliases, but they are not expanded.

       Alias  expansion  is done on the shell input before any other expansion except history expansion.  Therefore, if an alias is
       defined for the word ffoooo, alias expansion may be avoided by quoting part of the word, e.g. \\ffoooo.  Any form of quoting works,
       although  there is nothing to prevent an alias being defined for the quoted form such as \\ffoooo as well.  Also, if a separator
       such as &&&& is aliased, \\&&&& turns into the two tokens \\&& and &&, each of which may have been  aliased  separately.   Similarly
       for \\<<<<, \\>>||, etc.

       For  use with completion, which would remove an initial backslash followed by a character that isn't special, it may be more
       convenient to quote the word by starting with a single quote, i.e. ''ffoooo; completion will automatically add the trailing sin‐
       gle quote.

       There is a commonly encountered problem with aliases illustrated by the following code:

              aalliiaass eecchhoobbaarr==''eecchhoo bbaarr'';; eecchhoobbaarr

       This  prints a message that the command eecchhoobbaarr could not be found.  This happens because aliases are expanded when the code
       is read in; the entire line is read in one go, so that when eecchhoobbaarr is executed it is too late to expand the  newly  defined
       alias.   This  is often a problem in shell scripts, functions, and code executed with `ssoouurrccee' or `..'.  Consequently, use of
       functions rather than aliases is recommended in non-interactive code.

       Note also the unhelpful interaction of aliases and function definitions:

              aalliiaass ffuunncc==''nnoogglloobb ffuunncc''
              ffuunncc(()) {{
                  eecchhoo DDoo ssoommeetthhiinngg wwiitthh $$**
              }}

       Because aliases are expanded in function definitions, this causes the following command to be executed:

              nnoogglloobb ffuunncc(()) {{
                  eecchhoo DDoo ssoommeetthhiinngg wwiitthh $$**
              }}

       which defines nnoogglloobb as well as ffuunncc as functions with the body given.  To avoid this, either quote the name ffuunncc or use the
       alternative  function  definition form `ffuunnccttiioonn ffuunncc'.  Ensuring the alias is defined after the function works but is prob‐
       lematic if the code fragment might be re-executed.

QQUUOOTTIINNGG
       A character may be _q_u_o_t_e_d (that is, made to stand for itself) by preceding it with a `\\'.  `\\'  followed  by  a  newline  is
       ignored.

       A  string  enclosed  between  `$$'''  and  `''' is processed the same way as the string arguments of the pprriinntt builtin, and the
       resulting string is considered to be entirely quoted.  A literal `''' character can be included in the string  by  using  the
       `\\''' escape.

       All  characters enclosed between a pair of single quotes ('''') that is not preceded by a `$$' are quoted.  A single quote can‐
       not appear within single quotes unless the option RRCC__QQUUOOTTEESS is set, in which case a pair of single quotes are turned into  a
       single quote.  For example,

              pprriinntt ''''''''

       outputs nothing apart from a newline if RRCC__QQUUOOTTEESS is not set, but one single quote if it is set.

       Inside double quotes (""""), parameter and command substitution occur, and `\\' quotes the characters `\\', ```', `""', and `$$'.

RREEDDIIRREECCTTIIOONN
       If  a  command  is followed by && and job control is not active, then the default standard input for the command is the empty
       file //ddeevv//nnuullll.  Otherwise, the environment for the execution of a command contains the file  descriptors  of  the  invoking
       shell as modified by input/output specifications.

       The  following  may appear anywhere in a simple command or may precede or follow a complex command.  Expansion occurs before
       _w_o_r_d or _d_i_g_i_t is used except as noted below.  If the result of substitution on _w_o_r_d produces more than one  filename,  redi‐
       rection occurs for each separate filename in turn.

       << _w_o_r_d Open file _w_o_r_d for reading as standard input.

       <<>> _w_o_r_d
              Open file _w_o_r_d for reading and writing as standard input.  If the file does not exist then it is created.

       >> _w_o_r_d Open  file  _w_o_r_d for writing as standard output.  If the file does not exist then it is created.  If the file exists,
              and the CCLLOOBBBBEERR option is unset, this causes an error; otherwise, it is truncated to zero length.

       >>|| _w_o_r_d
       >>!! _w_o_r_d
              Same as >>, except that the file is truncated to zero length if it exists, even if CCLLOOBBBBEERR is unset.

       >>>> _w_o_r_d
              Open file _w_o_r_d for writing in append mode as standard output.  If the file does not exist, and the CCLLOOBBBBEERR option  is
              unset, this causes an error; otherwise, the file is created.

       >>>>|| _w_o_r_d
       >>>>!! _w_o_r_d
              Same as >>>>, except that the file is created if it does not exist, even if CCLLOOBBBBEERR is unset.

       <<<<[--] _w_o_r_d
              The shell input is read up to a line that is the same as _w_o_r_d, or to an end-of-file.  No parameter expansion, command
              substitution or filename generation is performed on _w_o_r_d.  The resulting document, called  a  _h_e_r_e_-_d_o_c_u_m_e_n_t,  becomes
              the standard input.

              If  any character of _w_o_r_d is quoted with single or double quotes or a `\\', no interpretation is placed upon the char‐
              acters of the document.  Otherwise, parameter and command substitution occurs, `\\' followed by a newline is  removed,
              and `\\' must be used to quote the characters `\\', `$$', ```' and the first character of _w_o_r_d.

              Note  that  _w_o_r_d itself does not undergo shell expansion.  Backquotes in _w_o_r_d do not have their usual effect; instead
              they behave similarly to double quotes, except that the backquotes themselves are passed  through  unchanged.   (This
              information  is given for completeness and it is not recommended that backquotes be used.)  Quotes in the form $$''_._._.''
              have their standard effect of expanding backslashed references to special characters.

              If <<<<-- is used, then all leading tabs are stripped from _w_o_r_d and from the document.

       <<<<<< _w_o_r_d
              Perform shell expansion on _w_o_r_d and pass the result to standard input.  This is known as a _h_e_r_e_-_s_t_r_i_n_g.  Compare  the
              use of _w_o_r_d in here-documents above, where _w_o_r_d does not undergo shell expansion.

       <<&& _n_u_m_b_e_r
       >>&& _n_u_m_b_e_r
              The standard input/output is duplicated from file descriptor _n_u_m_b_e_r (see _d_u_p_2(2)).

       <<&& --
       >>&& --   Close the standard input/output.

       <<&& pp
       >>&& pp   The input/output from/to the coprocess is moved to the standard input/output.

       >>&& _w_o_r_d
       &&>> _w_o_r_d
              (Except  where  `>>&& _w_o_r_d' matches one of the above syntaxes; `&&>>' can always be used to avoid this ambiguity.)  Redi‐
              rects both standard output and standard error (file descriptor 2) in the manner of `>> _w_o_r_d'.  Note that this does _n_o_t
              have the same effect as `>> _w_o_r_d 22>>&&11' in the presence of multios (see the section below).

       >>&&|| _w_o_r_d
       >>&&!! _w_o_r_d
       &&>>|| _w_o_r_d
       &&>>!! _w_o_r_d
              Redirects both standard output and standard error (file descriptor 2) in the manner of `>>|| _w_o_r_d'.

       >>>>&& _w_o_r_d
       &&>>>> _w_o_r_d
              Redirects both standard output and standard error (file descriptor 2) in the manner of `>>>> _w_o_r_d'.

       >>>>&&|| _w_o_r_d
       >>>>&&!! _w_o_r_d
       &&>>>>|| _w_o_r_d
       &&>>>>!! _w_o_r_d
              Redirects both standard output and standard error (file descriptor 2) in the manner of `>>>>|| _w_o_r_d'.

       If  one  of the above is preceded by a digit, then the file descriptor referred to is that specified by the digit instead of
       the default 0 or 1.  The order in which redirections are specified is significant.  The shell evaluates each redirection  in
       terms of the (_f_i_l_e _d_e_s_c_r_i_p_t_o_r, _f_i_l_e) association at the time of evaluation.  For example:

              ... 11>>_f_n_a_m_e 22>>&&11

       first associates file descriptor 1 with file _f_n_a_m_e.  It then associates file descriptor 2 with the file associated with file
       descriptor 1 (that is, _f_n_a_m_e).  If the order of redirections were reversed, file descriptor 2 would be associated  with  the
       terminal (assuming file descriptor 1 had been) and then file descriptor 1 would be associated with file _f_n_a_m_e.

       The `||&&' command separator described in _S_i_m_p_l_e _C_o_m_m_a_n_d_s _& _P_i_p_e_l_i_n_e_s in _z_s_h_m_i_s_c(1) is a shorthand for `22>>&&11 ||'.

       The  various  forms  of  process  substitution,  `<<((_l_i_s_t))', and `==((_l_i_s_t))' for input and `>>((_l_i_s_t))' for output, are often used
       together with redirection.  For example, if _w_o_r_d in an output redirection is of the form `>>((_l_i_s_t))' then the output is  piped
       to the command represented by _l_i_s_t.  See _P_r_o_c_e_s_s _S_u_b_s_t_i_t_u_t_i_o_n in _z_s_h_e_x_p_n(1).

OOPPEENNIINNGG FFIILLEE DDEESSCCRRIIPPTTOORRSS UUSSIINNGG PPAARRAAMMEETTEERRSS
       When  the  shell is parsing arguments to a command, and the shell option IIGGNNOORREE__BBRRAACCEESS is not set, a different form of redi‐
       rection is allowed: instead of a digit before the operator there is a valid shell identifier enclosed in braces.  The  shell
       will  open  a  new file descriptor that is guaranteed to be at least 10 and set the parameter named by the identifier to the
       file descriptor opened.  No whitespace is allowed between the closing brace and the redirection character.  For example:

              ... {{mmyyffdd}}>>&&11

       This opens a new file descriptor that is a duplicate of file descriptor 1 and sets the parameter mmyyffdd to the number  of  the
       file descriptor, which will be at least 10.  The new file descriptor can be written to using the syntax >>&&$$mmyyffdd.

       The  syntax {{_v_a_r_i_d}}>>&&--, for example {{mmyyffdd}}>>&&--, may be used to close a file descriptor opened in this fashion.  Note that the
       parameter given by _v_a_r_i_d must previously be set to a file descriptor in this case.

       It is an error to open or close a file descriptor in this fashion when the parameter is readonly.  However,  it  is  not  an
       error to read or write a file descriptor using <<&&$$_p_a_r_a_m or >>&&$$_p_a_r_a_m if _p_a_r_a_m is readonly.

       If  the  option  CCLLOOBBBBEERR is unset, it is an error to open a file descriptor using a parameter that is already set to an open
       file descriptor previously allocated by this mechanism.  Unsetting the parameter before  using  it  for  allocating  a  file
       descriptor avoids the error.

       Note  that  this mechanism merely allocates or closes a file descriptor; it does not perform any redirections from or to it.
       It is usually convenient to allocate a file descriptor prior to use as an argument to eexxeecc.  The syntax does not in any case
       work  when  used around complex commands such as parenthesised subshells or loops, where the opening brace is interpreted as
       part of a command list to be executed in the current shell.

       The following shows a typical sequence of allocation, use, and closing of a file descriptor:

              iinntteeggeerr mmyyffdd
              eexxeecc {{mmyyffdd}}>>~~//llooggss//mmyyllooggffiillee..ttxxtt
              pprriinntt TThhiiss iiss aa lloogg mmeessssaaggee.. >>&&$$mmyyffdd
              eexxeecc {{mmyyffdd}}>>&&--

       Note that the expansion of the variable in the expression >>&&$$mmyyffdd occurs at the point the redirection is  opened.   This  is
       after the expansion of command arguments and after any redirections to the left on the command line have been processed.

MMUULLTTIIOOSS
       If  the  user tries to open a file descriptor for writing more than once, the shell opens the file descriptor as a pipe to a
       process that copies its input to all the specified outputs, similar to tteeee, provided the MMUULLTTIIOOSS option is set, as it is  by
       default.  Thus:

              ddaattee >>ffoooo >>bbaarr

       writes the date to two files, named `ffoooo' and `bbaarr'.  Note that a pipe is an implicit redirection; thus

              ddaattee >>ffoooo || ccaatt

       writes the date to the file `ffoooo', and also pipes it to cat.

       Note also that redirections are always expanded in order.  This happens regardless of the setting of the MMUULLTTIIOOSS option, but
       with the option in effect there are additional consequences. For example, the meaning of  the  expression  >>&&11  will  change
       after a previous redirection:

              ddaattee >>&&11 >>oouuttppuutt

       In the case above, the >>&&11 refers to the standard output at the start of the line; the result is similar to the tteeee command.
       However, consider:

              ddaattee >>oouuttppuutt >>&&11

       As redirections are evaluated in order, when the >>&&11 is encountered the standard output  is  set  to  the  file  oouuttppuutt  and
       another copy of the output is therefore sent to that file.  This is unlikely to be what is intended.

       If  the  MMUULLTTIIOOSS  option  is set, the word after a redirection operator is also subjected to filename generation (globbing).
       Thus

              :: >> **

       will truncate all files in the current directory, assuming there's at least one.  (Without the MMUULLTTIIOOSS option, it would cre‐
       ate an empty file called `**'.)  Similarly, you can do

              eecchhoo eexxiitt 00 >>>> **..sshh

       If  the  user tries to open a file descriptor for reading more than once, the shell opens the file descriptor as a pipe to a
       process that copies all the specified inputs to its output in the order specified, similar  to  ccaatt,  provided  the  MMUULLTTIIOOSS
       option is set.  Thus

              ssoorrtt <<ffoooo <<ffuubbaarr

       or even

              ssoorrtt <<ff{{oooo,,uubbaarr}}

       is equivalent to `ccaatt ffoooo ffuubbaarr || ssoorrtt'.

       Expansion  of  the  redirection argument occurs at the point the redirection is opened, at the point described above for the
       expansion of the variable in >>&&$$mmyyffdd.

       Note that a pipe is an implicit redirection; thus

              ccaatt bbaarr || ssoorrtt <<ffoooo

       is equivalent to `ccaatt bbaarr ffoooo || ssoorrtt' (note the order of the inputs).

       If the MMUULLTTIIOOSS option is _u_nset, each redirection replaces the previous redirection for that file descriptor.   However,  all
       files redirected to are actually opened, so

              eecchhoo HHeelllloo >> bbaarr >> bbaazz

       when MMUULLTTIIOOSS is unset will truncate `bbaarr', and write `HHeelllloo' into `bbaazz'.

       There is a problem when an output multio is attached to an external program.  A simple example shows this:

              ccaatt ffiillee >>ffiillee11 >>ffiillee22
              ccaatt ffiillee11 ffiillee22

       Here, it is possible that the second `ccaatt' will not display the full contents of ffiillee11 and ffiillee22 (i.e. the original contents
       of ffiillee repeated twice).

       The reason for this is that the multios are spawned after the ccaatt process is forked from the parent  shell,  so  the  parent
       shell does not wait for the multios to finish writing data.  This means the command as shown can exit before ffiillee11 and ffiillee22
       are completely written.  As a workaround, it is possible to run the ccaatt process as part of a job in the current shell:

              {{ ccaatt ffiillee }} >>ffiillee >>ffiillee22

       Here, the {{_._._.}} job will pause to wait for both files to be written.

RREEDDIIRREECCTTIIOONNSS WWIITTHH NNOO CCOOMMMMAANNDD
       When a simple command consists of one or more redirection operators and zero or more parameter assignments, but  no  command
       name, zsh can behave in several ways.

       If  the  parameter  NNUULLLLCCMMDD  is  not set or the option CCSSHH__NNUULLLLCCMMDD is set, an error is caused.  This is the ccsshh behavior and
       CCSSHH__NNUULLLLCCMMDD is set by default when emulating ccsshh.

       If the option SSHH__NNUULLLLCCMMDD is set, the builtin `::' is inserted as a command with the given redirections.  This is the  default
       when emulating sshh or kksshh.

       Otherwise,  if the parameter NNUULLLLCCMMDD is set, its value will be used as a command with the given redirections.  If both NNUULLLL‐‐
       CCMMDD and RREEAADDNNUULLLLCCMMDD are set, then the value of the latter will be used instead of that of the former when the redirection is
       an input.  The default for NNUULLLLCCMMDD is `ccaatt' and for RREEAADDNNUULLLLCCMMDD is `mmoorree'. Thus

              << ffiillee

       shows  the  contents  of  ffiillee  on standard output, with paging if that is a terminal.  NNUULLLLCCMMDD and RREEAADDNNUULLLLCCMMDD may refer to
       shell functions.

CCOOMMMMAANNDD EEXXEECCUUTTIIOONN
       If a command name contains no slashes, the shell attempts to locate it.  If there exists a shell function by that name,  the
       function  is  invoked as described in the section `Functions'.  If there exists a shell builtin by that name, the builtin is
       invoked.

       Otherwise, the shell searches each element of $$ppaatthh for a directory containing an executable file  by  that  name.   If  the
       search is unsuccessful, the shell prints an error message and returns a nonzero exit status.

       If  execution  fails  because  the  file is not in executable format, and the file is not a directory, it is assumed to be a
       shell script.  //bbiinn//sshh is spawned to execute it.  If the program is a file beginning with `##!!', the remainder of  the  first
       line  specifies  an interpreter for the program.  The shell will execute the specified interpreter on operating systems that
       do not handle this executable format in the kernel.

       If no external command is found but a function ccoommmmaanndd__nnoott__ffoouunndd__hhaannddlleerr exists the shell executes this  function  with  all
       command  line  arguments.   The  return status of the function becomes the status of the command.  If the function wishes to
       mimic the behaviour of the shell when the command is not found, it should print the message  `ccoommmmaanndd  nnoott  ffoouunndd::  _c_m_d'  to
       standard  error  and  return status 127.  Note that the handler is executed in a subshell forked to execute an external com‐
       mand, hence changes to directories, shell parameters, etc. have no effect on the main shell.

FFUUNNCCTTIIOONNSS
       Shell functions are defined with the ffuunnccttiioonn reserved word or the special syntax `_f_u_n_c_n_a_m_e (())'.  Shell functions  are  read
       in  and  stored  internally.  Alias names are resolved when the function is read.  Functions are executed like commands with
       the arguments passed as positional parameters.  (See the section `Command Execution'.)

       Functions execute in the same process as the caller and share all files and present working directory with  the  caller.   A
       trap on EEXXIITT set inside a function is executed after the function completes in the environment of the caller.

       The rreettuurrnn builtin is used to return from function calls.

       Function identifiers can be listed with the ffuunnccttiioonnss builtin.  Functions can be undefined with the uunnffuunnccttiioonn builtin.

AAUUTTOOLLOOAADDIINNGG FFUUNNCCTTIIOONNSS
       A  function can be marked as _u_n_d_e_f_i_n_e_d using the aauuttoollooaadd builtin (or `ffuunnccttiioonnss --uu' or `ttyyppeesseett --ffuu').  Such a function has
       no body.  When the function is first executed, the shell searches for its definition using the elements of the  ffppaatthh  vari‐
       able.  Thus to define functions for autoloading, a typical sequence is:

              ffppaatthh==((~~//mmyyffuunnccss $$ffppaatthh))
              aauuttoollooaadd mmyyffuunncc11 mmyyffuunncc22 ......

       The  usual  alias  expansion during reading will be suppressed if the aauuttoollooaadd builtin or its equivalent is given the option
       --UU. This is recommended for the use of functions supplied with the zsh distribution.  Note that  for  functions  precompiled
       with  the zzccoommppiillee builtin command the flag --UU must be provided when the ..zzwwcc file is created, as the corresponding informa‐
       tion is compiled into the latter.

       For each _e_l_e_m_e_n_t in ffppaatthh, the shell looks for three possible files, the newest of which is used to load the definition  for
       the function:

       _e_l_e_m_e_n_t..zzwwcc
              A  file  created with the zzccoommppiillee builtin command, which is expected to contain the definitions for all functions in
              the directory named _e_l_e_m_e_n_t.  The file is treated in the same manner as a directory containing  files  for  functions
              and  is  searched  for  the definition of the function.   If the definition is not found, the search for a definition
              proceeds with the other two possibilities described below.

              If _e_l_e_m_e_n_t already includes a ..zzwwcc extension (i.e. the extension was  explicitly  given  by  the  user),  _e_l_e_m_e_n_t  is
              searched for the definition of the function without comparing its age to that of other files; in fact, there does not
              need to be any directory named _e_l_e_m_e_n_t without the suffix.  Thus including an element such as  `//uussrr//llooccaall//ffuunnccss..zzwwcc'
              in  ffppaatthh  will  speed  up the search for functions, with the disadvantage that functions included must be explicitly
              recompiled by hand before the shell notices any changes.

       _e_l_e_m_e_n_t//_f_u_n_c_t_i_o_n..zzwwcc
              A file created with zzccoommppiillee, which is expected to contain the definition for _f_u_n_c_t_i_o_n.  It may include  other  func‐
              tion  definitions  as  well, but those are neither loaded nor executed; a file found in this way is searched _o_n_l_y for
              the definition of _f_u_n_c_t_i_o_n.

       _e_l_e_m_e_n_t//_f_u_n_c_t_i_o_n
              A file of zsh command text, taken to be the definition for _f_u_n_c_t_i_o_n.

       In summary, the order of searching is, first, in the _p_a_r_e_n_t_s _o_f directories in ffppaatthh for the  newer  of  either  a  compiled
       directory  or a directory in ffppaatthh; second, if more than one of these contains a definition for the function that is sought,
       the leftmost in the ffppaatthh is chosen; and third, within a directory, the newer of either a compiled function or  an  ordinary
       function definition is used.

       If  the  KKSSHH__AAUUTTOOLLOOAADD option is set, or the file contains only a simple definition of the function, the file's contents will
       be executed.  This will normally define the function in question, but may also perform initialization, which is executed  in
       the  context  of  the  function execution, and may therefore define local parameters.  It is an error if the function is not
       defined by loading the file.

       Otherwise, the function body (with no surrounding `_f_u_n_c_n_a_m_e(()) {{_._._.}}') is taken to be the  complete  contents  of  the  file.
       This form allows the file to be used directly as an executable shell script.  If processing of the file results in the func‐
       tion being re-defined, the function itself is not re-executed.  To force the shell to perform initialization and  then  call
       the  function  defined, the file should contain initialization code (which will be executed then discarded) in addition to a
       complete function definition (which will be retained for subsequent calls to the function), and a call to  the  shell  func‐
       tion, including any arguments, at the end.

       For example, suppose the autoload file ffuunncc contains

              ffuunncc(()) {{ pprriinntt TThhiiss iiss ffuunncc;; }}
              pprriinntt ffuunncc iiss iinniittiiaalliizzeedd

       then `ffuunncc;; ffuunncc' with KKSSHH__AAUUTTOOLLOOAADD set will produce both messages on the first call, but only the message `TThhiiss iiss ffuunncc' on
       the second and subsequent calls.  Without KKSSHH__AAUUTTOOLLOOAADD set, it will produce the initialization message on  the  first  call,
       and the other message on the second and subsequent calls.

       It  is  also possible to create a function that is not marked as autoloaded, but which loads its own definition by searching
       ffppaatthh, by using `aauuttoollooaadd --XX' within a shell function.  For example, the following are equivalent:

              mmyyffuunncc(()) {{
                aauuttoollooaadd --XX
              }}
              mmyyffuunncc aarrggss......

       and

              uunnffuunnccttiioonn mmyyffuunncc   ## iiff mmyyffuunncc wwaass ddeeffiinneedd
              aauuttoollooaadd mmyyffuunncc
              mmyyffuunncc aarrggss......

       In fact, the ffuunnccttiioonnss command outputs `bbuuiillttiinn aauuttoollooaadd --XX' as the body of an autoloaded function.  This is done so that

              eevvaall ""$$((ffuunnccttiioonnss))""

       produces a reasonable result.  A true autoloaded function can be identified by the presence of the comment `## uunnddeeffiinneedd'  in
       the body, because all comments are discarded from defined functions.

       To load the definition of an autoloaded function mmyyffuunncc without executing mmyyffuunncc, use:

              aauuttoollooaadd ++XX mmyyffuunncc

AANNOONNYYMMOOUUSS FFUUNNCCTTIIOONNSS
       If  no  name is given for a function, it is `anonymous' and is handled specially.  Either form of function definition may be
       used: a `(())' with no preceding name, or a `ffuunnccttiioonn' with an immediately following open brace.   The  function  is  executed
       immediately at the point of definition and is not stored for future use.  The function name is set to `((aannoonn))'.

       Arguments  to  the  function may be specified as words following the closing brace defining the function, hence if there are
       none no arguments (other than $$00) are set.  This is a difference from the way other functions are  parsed:  normal  function
       definitions  may  be  followed  by  certain keywords such as `eellssee' or `ffii', which will be treated as arguments to anonymous
       functions, so that a newline or semicolon is needed to force keyword interpretation.

       Note also that the argument list of any enclosing script or function is hidden (as would be the case for any other  function
       called at this point).

       Redirections may be applied to the anonymous function in the same manner as to a current-shell structure enclosed in braces.
       The main use of anonymous functions is to provide a scope for local variables.  This is particularly convenient in  start-up
       files as these do not provide their own local variable scope.

       For example,

              vvaarriiaabbllee==oouuttssiiddee
              ffuunnccttiioonn {{
                llooccaall vvaarriiaabbllee==iinnssiiddee
                pprriinntt ""II aamm $$vvaarriiaabbllee wwiitthh aarrgguummeennttss $$**""
              }} tthhiiss aanndd tthhaatt
              pprriinntt ""II aamm $$vvaarriiaabbllee""

       outputs the following:

              II aamm iinnssiiddee wwiitthh aarrgguummeennttss tthhiiss aanndd tthhaatt
              II aamm oouuttssiiddee

       Note  that  function definitions with arguments that expand to nothing, for example `nnaammee==;; ffuunnccttiioonn $$nnaammee {{ _._._. }}', are not
       treated as anonymous functions.  Instead, they are treated as normal function definitions where the definition  is  silently
       discarded.

SSPPEECCIIAALL FFUUNNCCTTIIOONNSS
       Certain functions, if defined, have special meaning to the shell.

   HHooookk FFuunnccttiioonnss
       For  the  functions  below,  it  is  possible  to  define  an array that has the same name as the function with `__ffuunnccttiioonnss'
       appended.  Any element in such an array is taken as the name of a function to execute; it is executed in  the  same  context
       and  with  the  same  arguments  as  the basic function.  For example, if $$cchhppwwdd__ffuunnccttiioonnss is an array containing the values
       `mmyycchhppwwdd',  `cchhppwwdd__ssaavvee__ddiirrssttaacckk',  then  the  shell  attempts   to   execute   the   functions   `cchhppwwdd',   `mmyycchhppwwdd'   and
       `cchhppwwdd__ssaavvee__ddiirrssttaacckk', in that order.  Any function that does not exist is silently ignored.  A function found by this mech‐
       anism is referred to elsewhere as a `hook function'.  An error in any function causes subsequent functions not  to  be  run.
       Note  further that an error in a pprreeccmmdd hook causes an immediately following ppeerriiooddiicc function not to run (though it may run
       at the next opportunity).

       cchhppwwdd  Executed whenever the current working directory is changed.

       ppeerriiooddiicc
              If the parameter PPEERRIIOODD is set, this function is executed every $$PPEERRIIOODD seconds, just before a prompt.  Note that  if
              multiple  functions  are defined using the array ppeerriiooddiicc__ffuunnccttiioonnss only one period is applied to the complete set of
              functions, and the scheduled time is not reset if the list of functions is altered.  Hence the set  of  functions  is
              always called together.

       pprreeccmmdd Executed  before  each prompt.  Note that precommand functions are not re-executed simply because the command line is
              redrawn, as happens, for example, when a notification about an exiting job is displayed.

       pprreeeexxeecc
              Executed just after a command has been read and is about to be executed.  If the history mechanism is active (regard‐
              less  of  whether  the  line  was discarded from the history buffer), the string that the user typed is passed as the
              first argument, otherwise it is an empty string.  The actual  command  that  will  be  executed  (including  expanded
              aliases)  is passed in two different forms: the second argument is a single-line, size-limited version of the command
              (with things like function bodies elided); the third argument contains the full text that is being executed.

       zzsshhaaddddhhiissttoorryy
              Executed when a history line has been read interactively, but before it is executed.  The sole argument is  the  com‐
              plete history line (so that any terminating newline will still be present).

              If  any of the hook functions returns status 1 (or any non-zero value other than 2, though this is not guaranteed for
              future versions of the shell) the history line will not be saved, although it lingers in the history until  the  next
              line is executed, allowing you to reuse or edit it immediately.

              If  any  of  the hook functions returns status 2 the history line will be saved on the internal history list, but not
              written to the history file.  In case of a conflict, the first non-zero status value is taken.

              A hook function may call `ffcc --pp _._._.' to switch the history context so that the history is saved in a  different  file
              from  the  that  in  the  global HHIISSTTFFIILLEE parameter.  This is handled specially: the history context is automatically
              restored after the processing of the history line is finished.

              The following example function works with one of the options IINNCC__AAPPPPEENNDD__HHIISSTTOORRYY or SSHHAARREE__HHIISSTTOORRYY set, in  order  that
              the  line  is written out immediately after the history entry is added.  It first adds the history line to the normal
              history with the newline stripped, which is usually the correct behaviour.  Then it switches the history  context  so
              that the line will be written to a history file in the current directory.

                     zzsshhaaddddhhiissttoorryy(()) {{
                       pprriinntt --ssrr ---- $${{11%%%%$$''\\nn''}}
                       ffcc --pp ..zzsshh__llooccaall__hhiissttoorryy
                     }}

       zzsshheexxiitt
              Executed  at  the point where the main shell is about to exit normally.  This is not called by exiting subshells, nor
              when the eexxeecc precommand modifier is used before an external command.  Also, unlike TTRRAAPPEEXXIITT, it is not  called  when
              functions exit.

   TTrraapp FFuunnccttiioonnss
       The functions below are treated specially but do not have corresponding hook arrays.

       TTRRAAPP_N_A_L
              If  defined  and  non-null, this function will be executed whenever the shell catches a signal SSIIGG_N_A_L, where _N_A_L is a
              signal name as specified for the kkiillll builtin.  The signal number will be passed as the first parameter to the  func‐
              tion.

              If a function of this form is defined and null, the shell and processes spawned by it will ignore SSIIGG_N_A_L.

              The return status from the function is handled specially.  If it is zero, the signal is assumed to have been handled,
              and execution continues normally.  Otherwise, the shell will behave as interrupted except that the return  status  of
              the trap is retained.

              Programs  terminated by uncaught signals typically return the status 128 plus the signal number.  Hence the following
              causes the handler for SSIIGGIINNTT to print a message, then mimic the usual effect of the signal.

                     TTRRAAPPIINNTT(()) {{
                       pprriinntt ""CCaauugghhtt SSIIGGIINNTT,, aabboorrttiinngg..""
                       rreettuurrnn $$(((( 112288 ++ $$11 ))))
                     }}

              The functions TTRRAAPPZZEERRRR, TTRRAAPPDDEEBBUUGG and TTRRAAPPEEXXIITT are never executed inside other traps.

       TTRRAAPPDDEEBBUUGG
              If the option DDEEBBUUGG__BBEEFFOORREE__CCMMDD is set (as it is by default), executed before each command; otherwise  executed  after
              each  command.  See the description of the ttrraapp builtin in _z_s_h_b_u_i_l_t_i_n_s(1) for details of additional features provided
              in debug traps.

       TTRRAAPPEEXXIITT
              Executed when the shell exits, or when the current function exits if defined inside a function.  The value of  $$??  at
              the start of execution is the exit status of the shell or the return status of the function exiting.

       TTRRAAPPZZEERRRR
              Executed  whenever  a  command  has  a  non-zero  exit  status.  However, the function is not executed if the command
              occurred in a sublist followed by `&&&&' or `||||'; only the final command in a sublist of this type causes the  trap  to
              be  executed.   The function TTRRAAPPEERRRR acts the same as TTRRAAPPZZEERRRR on systems where there is no SSIIGGEERRRR (this is the usual
              case).

       The functions beginning `TTRRAAPP' may alternatively be defined with the ttrraapp builtin:  this may be preferable  for  some  uses.
       Setting  a trap with one form removes any trap of the other form for the same signal; removing a trap in either form removes
       all traps for the same signal.  The forms

              TTRRAAPPNNAALL(()) {{
               ## ccooddee
              }}

       ('function traps') and

              ttrraapp ''
               ## ccooddee
              '' NNAALL

       ('list traps') are equivalent in most ways, the exceptions being the following:

       ·      Function traps have all the properties of normal functions, appearing in the list of functions and being called  with
              their own function context rather than the context where the trap was triggered.

       ·      The return status from function traps is special, whereas a return from a list trap causes the surrounding context to
              return with the given status.

       ·      Function traps are not reset within subshells, in accordance with zsh behaviour; list traps are reset, in  accordance
              with POSIX behaviour.

JJOOBBSS
       If  the  MMOONNIITTOORR option is set, an interactive shell associates a _j_o_b with each pipeline.  It keeps a table of current jobs,
       printed by the jjoobbss command, and assigns them small integer numbers.  When a job is started  asynchronously  with  `&&',  the
       shell prints a line to standard error which looks like:

              [[11]] 11223344

       indicating  that the job which was started asynchronously was job number 1 and had one (top-level) process, whose process ID
       was 1234.

       If a job is started with `&&||' or `&&!!', then that job is immediately disowned.  After startup, it does not have  a  place  in
       the job table, and is not subject to the job control features described here.

       If  you  are running a job and wish to do something else you may hit the key ^Z (control-Z) which sends a TTSSTTPP signal to the
       current job:  this key may be redefined by the ssuusspp option of the external ssttttyy command.  The shell will then normally indi‐
       cate that the job has been `suspended', and print another prompt.  You can then manipulate the state of this job, putting it
       in the background with the bbgg command, or run some other commands and then eventually bring the job back into the foreground
       with  the  foreground  command ffgg.  A ^Z takes effect immediately and is like an interrupt in that pending output and unread
       input are discarded when it is typed.

       A job being run in the background will suspend if it tries to read from the terminal.

       Note that if the job running in the foreground is a shell function, then suspending it will have the effect of  causing  the
       shell to fork.  This is necessary to separate the function's state from that of the parent shell performing the job control,
       so that the latter can return to the command line prompt.  As a result, even if ffgg is used to continue the job the  function
       will  no  longer be part of the parent shell, and any variables set by the function will not be visible in the parent shell.
       Thus the behaviour is different from the case where the function was never suspended.  Zsh  is  different  from  many  other
       shells in this regard.

       One additional side effect is that use of ddiissoowwnn with a job created by suspending shell code in this fashion is delayed: the
       job can only be disowned once any process started from the parent shell has terminated.  At that  point,  the  disowned  job
       disappears silently from the job list.

       The  same behaviour is found when the shell is executing code as the right hand side of a pipeline or any complex shell con‐
       struct such as iiff, ffoorr, etc., in order that the entire block of code can be managed as a single job.   Background  jobs  are
       normally  allowed  to  produce  output,  but  this can be disabled by giving the command `ssttttyy ttoossttoopp'.  If you set this tty
       option, then background jobs will suspend when they try to produce output like they do when they try to read input.

       When a command is suspended and continued later with the ffgg or wwaaiitt builtins, zsh restores tty modes  that  were  in  effect
       when  it  was  suspended.   This (intentionally) does not apply if the command is continued via `kkiillll --CCOONNTT', nor when it is
       continued with bbgg.

       There are several ways to refer to jobs in the shell.  A job can be referred to by the process ID of any process of the  job
       or by one of the following:

       %%_n_u_m_b_e_r
              The job with the given number.
       %%_s_t_r_i_n_g
              The last job whose command line begins with _s_t_r_i_n_g.
       %%??_s_t_r_i_n_g
              The last job whose command line contains _s_t_r_i_n_g.
       %%%%     Current job.
       %%++     Equivalent to `%%%%'.
       %%--     Previous job.

       The  shell  learns  immediately whenever a process changes state.  It normally informs you whenever a job becomes blocked so
       that no further progress is possible.  If the NNOOTTIIFFYY option is not set, it waits until just before it prints a prompt before
       it informs you.  All such notifications are sent directly to the terminal, not to the standard output or standard error.

       When the monitor mode is on, each background job that completes triggers any trap set for CCHHLLDD.

       When  you  try to leave the shell while jobs are running or suspended, you will be warned that `You have suspended (running)
       jobs'.  You may use the jjoobbss command to see what they are.  If you do this or immediately try to exit again, the shell  will
       not warn you a second time; the suspended jobs will be terminated, and the running jobs will be sent a SSIIGGHHUUPP signal, if the
       HHUUPP option is set.

       To avoid having the shell terminate the running jobs, either use the nnoohhuupp command (see _n_o_h_u_p(1)) or the ddiissoowwnn builtin.

SSIIGGNNAALLSS
       The IINNTT and QQUUIITT signals for an invoked command are ignored if the command is followed by `&&' and the MMOONNIITTOORR option is  not
       active.   The  shell  itself always ignores the QQUUIITT signal.  Otherwise, signals have the values inherited by the shell from
       its parent (but see the TTRRAAPP_N_A_L special functions in the section `Functions').

       Certain jobs are run asynchronously by the shell other than those explicitly put into the background; even  in  cases  where
       the shell would usually wait for such jobs, an explicit eexxiitt command or exit due to the option EERRRR__EEXXIITT will cause the shell
       to exit without waiting.  Examples of such asynchronous jobs are process substitution, see the section PROCESS  SUBSTITUTION
       in the _z_s_h_e_x_p_n(1) manual page, and the handler processes for multios, see the section MULTIOS in the _z_s_h_m_i_s_c(1) manual page.

AARRIITTHHMMEETTIICC EEVVAALLUUAATTIIOONN
       The shell can perform integer and floating point arithmetic, either using the builtin lleett, or via a substitution of the form
       $$((((_._._.)))).  For integers, the shell is usually compiled to use 8-byte precision where this is available, otherwise  precision
       is  4  bytes.   This  can  be tested, for example, by giving the command `pprriinntt -- $$(((( 1122334455667788990011 ))))'; if the number appears
       unchanged, the precision is at least 8 bytes.  Floating point arithmetic always uses the `double' type with whatever  corre‐
       sponding precision is provided by the compiler and the library.

       The  lleett  builtin command takes arithmetic expressions as arguments; each is evaluated separately.  Since many of the arith‐
       metic operators, as well as spaces, require quoting, an alternative form is provided: for any command which  begins  with  a
       `((((',  all the characters until a matching `))))' are treated as a quoted expression and arithmetic expansion performed as for
       an argument of lleett.  More precisely, `((((_._._.))))' is equivalent to `lleett ""_._._.""'.  The return status is 0 if the arithmetic value
       of the expression is non-zero, 1 if it is zero, and 2 if an error occurred.

       For example, the following statement

              (((( vvaall == 22 ++ 11 ))))

       is equivalent to

              lleett ""vvaall == 22 ++ 11""

       both assigning the value 3 to the shell variable vvaall and returning a zero status.

       Integers  can  be  in  bases  other  than 10.  A leading `00xx' or `00XX' denotes hexadecimal and a leading `00bb' or `00BB' binary.
       Integers may also be of the form `_b_a_s_e##_n', where _b_a_s_e is a decimal number between two and thirty-six representing the arith‐
       metic  base  and _n is a number in that base (for example, `1166##ffff' is 255 in hexadecimal).  The _b_a_s_e## may also be omitted, in
       which case base 10 is used.  For backwards compatibility the form `[[_b_a_s_e]]_n' is also accepted.

       An integer expression or a base given in the form `_b_a_s_e##_n' may contain underscores (`__') after the leading digit for  visual
       guidance;  these  are  ignored  in  computation.   Examples are 11__000000__000000 or 00xxffffffff__ffffffff which are equivalent to 11000000000000 and
       00xxffffffffffffffff respectively.

       It is also possible to specify a base to be used for output in the form `[[##_b_a_s_e]]', for example `[[##1166]]'.  This is  used  when
       outputting  arithmetical substitutions or when assigning to scalar parameters, but an explicitly defined integer or floating
       point parameter will not be affected.  If an integer variable is implicitly defined by an arithmetic  expression,  any  base
       specified in this way will be set as the variable's output arithmetic base as if the option `--ii _b_a_s_e' to the ttyyppeesseett builtin
       had been used.  The expression has no precedence and if it occurs more than once in  a  mathematical  expression,  the  last
       encountered is used.  For clarity it is recommended that it appear at the beginning of an expression.  As an example:

              ttyyppeesseett --ii 1166 yy
              pprriinntt $$(((( [[##88]] xx == 3322,, yy == 3322 ))))
              pprriinntt $$xx $$yy

       outputs  first  `88##4400',  the  rightmost value in the given output base, and then `88##4400 1166##2200', because yy has been explicitly
       declared to have output base 16, while xx (assuming it does not already exist) is implicitly typed by the arithmetic  evalua‐
       tion, where it acquires the output base 8.

       The  _b_a_s_e may be replaced or followed by an underscore, which may itself be followed by a positive integer (if it is missing
       the value 3 is used).  This indicates that underscores should be inserted into the output string, grouping  the  number  for
       visual clarity.  The following integer specifies the number of digits to group together.  For example:

              sseettoopptt ccbbaasseess
              pprriinntt $$(((( [[##1166__44]] 6655553366 **** 22 ))))

       outputs `00xx11__00000000__00000000'.

       The feature can be used with floating point numbers, in which case the base must be omitted; grouping is away from the deci‐
       mal point.  For example,

              zzmmooddllooaadd zzsshh//mmaatthhffuunncc
              pprriinntt $$(((( [[##__]] ssqqrrtt((11ee77)) ))))

       outputs `33__116622..227777__666600__116688__337799__55' (the number of decimal places shown may vary).

       If the CC__BBAASSEESS option is set, hexadecimal numbers are output in the standard C format, for example  `00xxFFFF'  instead  of  the
       usual  `1166##FFFF'.   If the option OOCCTTAALL__ZZEERROOEESS is also set (it is not by default), octal numbers will be treated similarly and
       hence appear as `007777' instead of `88##7777'.  This option has no effect on the output of bases other than hexadecimal and octal,
       and these formats are always understood on input.

       When an output base is specified using the `[[##_b_a_s_e]]' syntax, an appropriate base prefix will be output if necessary, so that
       the value output is valid syntax for input.  If the ## is doubled, for example `[[####1166]]', then no base prefix is output.

       Floating point constants are recognized by the presence of a decimal point or an exponent.  The decimal  point  may  be  the
       first  character  of the constant, but the exponent character ee or EE may not, as it will be taken for a parameter name.  All
       numeric parts (before and after the decimal point and in the exponent) may contain underscores after the leading  digit  for
       visual guidance; these are ignored in computation.

       An arithmetic expression uses nearly the same syntax and associativity of expressions as in C.

       In the native mode of operation, the following operators are supported (listed in decreasing order of precedence):

       ++ -- !! ~~ ++++ ----
              unary plus/minus, logical NOT, complement, {pre,post}{in,de}crement
       <<<< >>>>  bitwise shift left, right
       &&      bitwise AND
       ^^      bitwise XOR
       ||      bitwise OR
       ****     exponentiation
       ** // %%  multiplication, division, modulus (remainder)
       ++ --    addition, subtraction
       << >> <<== >>==
              comparison
       ==== !!==  equality and inequality
       &&&&     logical AND
       |||| ^^^^  logical OR, XOR
       ?? ::    ternary operator
       == ++== --== **== //== %%== &&== ^^== ||== <<<<== >>>>== &&&&== ||||== ^^^^== ****==
              assignment
       ,,      comma operator

       The  operators  `&&&&',  `||||',  `&&&&==', and `||||==' are short-circuiting, and only one of the latter two expressions in a ternary
       operator is evaluated.  Note the precedence of the bitwise AND, OR, and XOR operators.

       With the option CC__PPRREECCEEDDEENNCCEESS the precedences (but no other properties) of the operators are altered to be the same as those
       in most other languages that support the relevant operators:

       ++ -- !! ~~ ++++ ----
              unary plus/minus, logical NOT, complement, {pre,post}{in,de}crement
       ****     exponentiation
       ** // %%  multiplication, division, modulus (remainder)
       ++ --    addition, subtraction
       <<<< >>>>  bitwise shift left, right
       << >> <<== >>==
              comparison
       ==== !!==  equality and inequality
       &&      bitwise AND
       ^^      bitwise XOR
       ||      bitwise OR
       &&&&     logical AND
       ^^^^     logical XOR
       ||||     logical OR
       ?? ::    ternary operator
       == ++== --== **== //== %%== &&== ^^== ||== <<<<== >>>>== &&&&== ||||== ^^^^== ****==
              assignment
       ,,      comma operator

       Note  the  precedence  of exponentiation in both cases is below that of unary operators, hence `--33****22' evaluates as `99', not
       `--99'.  Use parentheses where necessary: `--((33****22))'.  This is for compatibility with other shells.

       Mathematical functions can be called with the syntax `_f_u_n_c((_a_r_g_s))', where the function decides if  the  _a_r_g_s  is  used  as  a
       string  or  a  comma-separated  list  of  arithmetic  expressions.  The shell currently defines no mathematical functions by
       default, but the module zzsshh//mmaatthhffuunncc may be loaded with the zzmmooddllooaadd builtin to provide standard floating point mathematical
       functions.

       An  expression  of  the form `####_x' where _x is any character sequence such as `aa', `^^AA', or `\\MM--\\CC--xx' gives the value of this
       character and an expression of the form `##_n_a_m_e' gives the value of the first character of  the  contents  of  the  parameter
       _n_a_m_e.   Character values are according to the character set used in the current locale; for multibyte character handling the
       option MMUULLTTIIBBYYTTEE must be set.  Note that this form is different from `$$##_n_a_m_e', a standard parameter substitution which gives
       the length of the parameter _n_a_m_e.  `##\\' is accepted instead of `####', but its use is deprecated.

       Named  parameters and subscripted arrays can be referenced by name within an arithmetic expression without using the parame‐
       ter expansion syntax.  For example,

              ((((vvaall22 == vvaall11 ** 22))))

       assigns twice the value of $$vvaall11 to the parameter named vvaall22.

       An internal integer representation of a named parameter can be specified with the iinntteeggeerr builtin.  Arithmetic evaluation is
       performed  on the value of each assignment to a named parameter declared integer in this manner.  Assigning a floating point
       number to an integer results in rounding towards zero.

       Likewise, floating point numbers can be declared with the ffllooaatt builtin; there are two types, differing only in their output
       format, as described for the ttyyppeesseett builtin.  The output format can be bypassed by using arithmetic substitution instead of
       the parameter substitution, i.e. `$${{_f_l_o_a_t}}' uses the defined format, but `$$((((_f_l_o_a_t))))' uses a generic floating point format.

       Promotion of integer to floating point values is performed where necessary.  In addition, if any operator which requires  an
       integer  (`&&',  `||',  `^^',  `<<<<', `>>>>' and their equivalents with assignment) is given a floating point argument, it will be
       silently rounded towards zero except for `~~' which rounds down.

       Users should beware that, in common with many other programming languages but not software  designed  for  calculation,  the
       evaluation  of  an expression in zsh is taken a term at a time and promotion of integers to floating point does not occur in
       terms only containing integers.  A typical result of this is that a division such as 66//88 is truncated, in this being rounded
       towards  0.   The  FFOORRCCEE__FFLLOOAATT  shell option can be used in scripts or functions where floating point evaluation is required
       throughout.

       Scalar variables can hold integer or floating point values at different times; there is no memory of  the  numeric  type  in
       this case.

       If a variable is first assigned in a numeric context without previously being declared, it will be implicitly typed as iinnttee‐‐
       ggeerr or ffllooaatt and retain that type either until the type is explicitly changed or until the end of the scope.  This can  have
       unforeseen consequences.  For example, in the loop

              ffoorr (((( ff == 00;; ff << 11;; ff ++== 00..11 ))));; ddoo
              ## uussee $$ff
              ddoonnee

       if  ff  has  not  already been declared, the first assignment will cause it to be created as an integer, and consequently the
       operation `ff ++== 00..11' will always cause the result to be truncated to zero, so that the loop will fail.  A simple  fix  would
       be to turn the initialization into `ff == 00..00'.  It is therefore best to declare numeric variables with explicit types.

CCOONNDDIITTIIOONNAALL EEXXPPRREESSSSIIOONNSS
       A  _c_o_n_d_i_t_i_o_n_a_l  _e_x_p_r_e_s_s_i_o_n  is  used  with the [[[[ compound command to test attributes of files and to compare strings.  Each
       expression can be constructed from one or more of the following unary or binary expressions:

       --aa _f_i_l_e
              true if _f_i_l_e exists.

       --bb _f_i_l_e
              true if _f_i_l_e exists and is a block special file.

       --cc _f_i_l_e
              true if _f_i_l_e exists and is a character special file.

       --dd _f_i_l_e
              true if _f_i_l_e exists and is a directory.

       --ee _f_i_l_e
              true if _f_i_l_e exists.

       --ff _f_i_l_e
              true if _f_i_l_e exists and is a regular file.

       --gg _f_i_l_e
              true if _f_i_l_e exists and has its setgid bit set.

       --hh _f_i_l_e
              true if _f_i_l_e exists and is a symbolic link.

       --kk _f_i_l_e
              true if _f_i_l_e exists and has its sticky bit set.

       --nn _s_t_r_i_n_g
              true if length of _s_t_r_i_n_g is non-zero.

       --oo _o_p_t_i_o_n
              true if option named _o_p_t_i_o_n is on.  _o_p_t_i_o_n may be a single character, in which case it  is  a  single  letter  option
              name.  (See the section `Specifying Options'.)

       --pp _f_i_l_e
              true if _f_i_l_e exists and is a FIFO special file (named pipe).

       --rr _f_i_l_e
              true if _f_i_l_e exists and is readable by current process.

       --ss _f_i_l_e
              true if _f_i_l_e exists and has size greater than zero.

       --tt _f_d  true if file descriptor number _f_d is open and associated with a terminal device.  (note: _f_d is not optional)

       --uu _f_i_l_e
              true if _f_i_l_e exists and has its setuid bit set.

       --vv _v_a_r_n_a_m_e
              true if shell variable _v_a_r_n_a_m_e is set.

       --ww _f_i_l_e
              true if _f_i_l_e exists and is writable by current process.

       --xx _f_i_l_e
              true  if  _f_i_l_e  exists  and  is  executable  by current process.  If _f_i_l_e exists and is a directory, then the current
              process has permission to search in the directory.

       --zz _s_t_r_i_n_g
              true if length of _s_t_r_i_n_g is zero.

       --LL _f_i_l_e
              true if _f_i_l_e exists and is a symbolic link.

       --OO _f_i_l_e
              true if _f_i_l_e exists and is owned by the effective user ID of this process.

       --GG _f_i_l_e
              true if _f_i_l_e exists and its group matches the effective group ID of this process.

       --SS _f_i_l_e
              true if _f_i_l_e exists and is a socket.

       --NN _f_i_l_e
              true if _f_i_l_e exists and its access time is not newer than its modification time.

       _f_i_l_e_1 --nntt _f_i_l_e_2
              true if _f_i_l_e_1 exists and is newer than _f_i_l_e_2.

       _f_i_l_e_1 --oott _f_i_l_e_2
              true if _f_i_l_e_1 exists and is older than _f_i_l_e_2.

       _f_i_l_e_1 --eeff _f_i_l_e_2
              true if _f_i_l_e_1 and _f_i_l_e_2 exist and refer to the same file.

       _s_t_r_i_n_g == _p_a_t_t_e_r_n
       _s_t_r_i_n_g ==== _p_a_t_t_e_r_n
              true if _s_t_r_i_n_g matches _p_a_t_t_e_r_n.  The two forms are exactly equivalent.  The `==' form is the traditional shell  syntax
              (and hence the only one generally used with the tteesstt and [[ builtins); the `====' form provides compatibility with other
              sorts of computer language.

       _s_t_r_i_n_g !!== _p_a_t_t_e_r_n
              true if _s_t_r_i_n_g does not match _p_a_t_t_e_r_n.

       _s_t_r_i_n_g ==~~ _r_e_g_e_x_p
              true if _s_t_r_i_n_g matches the regular expression _r_e_g_e_x_p.  If the option RREE__MMAATTCCHH__PPCCRREE is set _r_e_g_e_x_p is tested as a  PCRE
              regular  expression  using  the  zzsshh//ppccrree  module, else it is tested as a POSIX extended regular expression using the
              zzsshh//rreeggeexx module.  Upon successful match, some variables will be updated; no variables are changed  if  the  matching
              fails.

              If the option BBAASSHH__RREEMMAATTCCHH is not set the scalar parameter MMAATTCCHH is set to the substring that matched the pattern and
              the integer parameters MMBBEEGGIINN and MMEENNDD to the index of the start and end, respectively, of the match in _s_t_r_i_n_g,  such
              that  if  _s_t_r_i_n_g  is  contained in variable vvaarr the expression `$${{vvaarr[[$$MMBBEEGGIINN,,$$MMEENNDD]]}}' is identical to `$$MMAATTCCHH'.  The
              setting of the option KKSSHH__AARRRRAAYYSS is respected.  Likewise, the array mmaattcchh is  set  to  the  substrings  that  matched
              parenthesised  subexpressions  and  the arrays mmbbeeggiinn and mmeenndd to the indices of the start and end positions, respec‐
              tively, of the substrings within _s_t_r_i_n_g.  The arrays are not set if there were no parenthesised subexpresssions.  For
              example,  if  the  string  `aa  sshhoorrtt  ssttrriinngg' is matched against the regular expression `ss((......))tt', then (assuming the
              option KKSSHH__AARRRRAAYYSS is not set) MMAATTCCHH, MMBBEEGGIINN and MMEENNDD are `sshhoorrtt', 33 and 77, respectively, while mmaattcchh, mmbbeeggiinn and mmeenndd
              are single entry arrays containing the strings `hhoorr', `44' and `66', respectively.

              If the option BBAASSHH__RREEMMAATTCCHH is set the array BBAASSHH__RREEMMAATTCCHH is set to the substring that matched the pattern followed by
              the substrings that matched parenthesised subexpressions within the pattern.

       _s_t_r_i_n_g_1 << _s_t_r_i_n_g_2
              true if _s_t_r_i_n_g_1 comes before _s_t_r_i_n_g_2 based on ASCII value of their characters.

       _s_t_r_i_n_g_1 >> _s_t_r_i_n_g_2
              true if _s_t_r_i_n_g_1 comes after _s_t_r_i_n_g_2 based on ASCII value of their characters.

       _e_x_p_1 --eeqq _e_x_p_2
              true if _e_x_p_1 is numerically equal to _e_x_p_2.  Note that for purely numeric  comparisons  use  of  the  ((((_._._.))))  builtin
              described in the section `ARITHMETIC EVALUATION' is more convenient than conditional expressions.

       _e_x_p_1 --nnee _e_x_p_2
              true if _e_x_p_1 is numerically not equal to _e_x_p_2.

       _e_x_p_1 --lltt _e_x_p_2
              true if _e_x_p_1 is numerically less than _e_x_p_2.

       _e_x_p_1 --ggtt _e_x_p_2
              true if _e_x_p_1 is numerically greater than _e_x_p_2.

       _e_x_p_1 --llee _e_x_p_2
              true if _e_x_p_1 is numerically less than or equal to _e_x_p_2.

       _e_x_p_1 --ggee _e_x_p_2
              true if _e_x_p_1 is numerically greater than or equal to _e_x_p_2.

       (( _e_x_p ))
              true if _e_x_p is true.

       !! _e_x_p  true if _e_x_p is false.

       _e_x_p_1 &&&& _e_x_p_2
              true if _e_x_p_1 and _e_x_p_2 are both true.

       _e_x_p_1 |||| _e_x_p_2
              true if either _e_x_p_1 or _e_x_p_2 is true.

       For  compatibility, if there is a single argument that is not syntactically significant, typically a variable, the condition
       is treated as a test for whether the expression expands as a string of non-zero length.  In other words, [[[[ $$vvaarr ]]]]  is  the
       same as [[[[ --nn $$vvaarr ]]]].  It is recommended that the second, explicit, form be used where possible.

       Normal  shell  expansion  is  performed  on the _f_i_l_e, _s_t_r_i_n_g and _p_a_t_t_e_r_n arguments, but the result of each expansion is con‐
       strained to be a single word, similar to the effect of double quotes.

       Filename generation is not performed on any form of argument to conditions.  However, it can be forced  in  any  case  where
       normal  shell  expansion  is valid and when the option EEXXTTEENNDDEEDD__GGLLOOBB is in effect by using an explicit glob qualifier of the
       form ((##qq)) at the end of the string.  A normal glob qualifier expression may appear between the `qq' and the closing parenthe‐
       sis;  if  none  appears the expression has no effect beyond causing filename generation.  The results of filename generation
       are joined together to form a single word, as with the results of other forms of expansion.

       This special use of filename generation is only available with the [[[[ syntax.  If the condition occurs within the [[ or  tteesstt
       builtin  commands  then  globbing occurs instead as part of normal command line expansion before the condition is evaluated.
       In this case it may generate multiple words which are likely to confuse the syntax of the test command.

       For example,

              [[[[ --nn ffiillee**((##qqNN)) ]]]]

       produces status zero if and only if there is at least one file in the current directory beginning with  the  string  `ffiillee'.
       The globbing qualifier NN ensures that the expression is empty if there is no matching file.

       Pattern  metacharacters  are  active for the _p_a_t_t_e_r_n arguments; the patterns are the same as those used for filename genera‐
       tion, see _z_s_h_e_x_p_n(1), but there is no special behaviour of `//' nor initial dots, and no glob qualifiers are allowed.

       In each of the above expressions, if _f_i_l_e is of the form `//ddeevv//ffdd//_n', where _n is an integer, then the test  applied  to  the
       open file whose descriptor number is _n, even if the underlying system does not support the //ddeevv//ffdd directory.

       In  the  forms  which  do  numeric  comparison, the expressions _e_x_p undergo arithmetic expansion as if they were enclosed in
       $$((((_._._.)))).

       For example, the following:

              [[[[ (( --ff ffoooo |||| --ff bbaarr )) &&&& $$rreeppoorrtt == yy** ]]]] &&&& pprriinntt FFiillee eexxiissttss..

       tests if either file ffoooo or file bbaarr exists, and if so, if the value of the parameter rreeppoorrtt begins with `yy';  if  the  com‐
       plete condition is true, the message `FFiillee eexxiissttss..' is printed.

EEXXPPAANNSSIIOONN OOFF PPRROOMMPPTT SSEEQQUUEENNCCEESS
       Prompt  sequences  undergo a special form of expansion.  This type of expansion is also available using the --PP option to the
       pprriinntt builtin.

       If the PPRROOMMPPTT__SSUUBBSSTT option is set, the prompt string is first subjected to _p_a_r_a_m_e_t_e_r  _e_x_p_a_n_s_i_o_n,  _c_o_m_m_a_n_d  _s_u_b_s_t_i_t_u_t_i_o_n  and
       _a_r_i_t_h_m_e_t_i_c _e_x_p_a_n_s_i_o_n.  See _z_s_h_e_x_p_n(1).

       Certain escape sequences may be recognised in the prompt string.

       If  the  PPRROOMMPPTT__BBAANNGG  option is set, a `!!' in the prompt is replaced by the current history event number.  A literal `!!' may
       then be represented as `!!!!'.

       If the PPRROOMMPPTT__PPEERRCCEENNTT option is set, certain escape sequences that start with `%%' are expanded.  Many escapes  are  followed
       by  a  single character, although some of these take an optional integer argument that should appear between the `%%' and the
       next character of the sequence.  More complicated escape sequences are available to provide conditional expansion.

SSIIMMPPLLEE PPRROOMMPPTT EESSCCAAPPEESS
   SSppeecciiaall cchhaarraacctteerrss
       %%%%     A `%%'.

       %%))     A `))'.

   LLooggiinn iinnffoorrmmaattiioonn
       %%ll     The line (tty) the user is logged in on, without `//ddeevv//' prefix.  If the name starts with `//ddeevv//ttttyy', that prefix  is
              stripped.

       %%MM     The full machine hostname.

       %%mm     The  hostname  up to the first `..'.  An integer may follow the `%%' to specify how many components of the hostname are
              desired.  With a negative integer, trailing components of the hostname are shown.

       %%nn     $$UUSSEERRNNAAMMEE.

       %%yy     The line (tty) the user is logged in on, without `//ddeevv//' prefix.  This does not treat `//ddeevv//ttttyy' names specially.

   SShheellll ssttaattee
       %%##     A `##' if the shell is running with privileges, a `%%' if not.  Equivalent to `%%((!!..##..%%%%))'.  The definition  of  `privi‐
              leged', for these purposes, is that either the effective user ID is zero, or, if POSIX.1e capabilities are supported,
              that at least one capability is raised in either the Effective or Inheritable capability vectors.

       %%??     The return status of the last command executed just before the prompt.

       %%__     The status of the parser, i.e. the shell constructs (like `iiff' and `ffoorr') that have been started on the command line.
              If  given  an integer number that many strings will be printed; zero or negative or no integer means print as many as
              there are.  This is most useful in prompts PPSS22 for continuation lines and PPSS44 for debugging with the  XXTTRRAACCEE  option;
              in the latter case it will also work non-interactively.

       %%^^     The  status  of the parser in reverse. This is the same as `%%__' other than the order of strings.  It is often used in
              RRPPSS22.

       %%dd
       %%//     Current working directory.  If an integer follows the `%%', it specifies a number of trailing components of  the  cur‐
              rent  working  directory  to  show; zero means the whole path.  A negative integer specifies leading components, i.e.
              %%--11dd specifies the first component.

       %%~~     As %%dd and %%//, but if the current working directory starts with $$HHOOMMEE, that part is replaced by a `~~'. Furthermore, if
              it  has  a  named  directory as its prefix, that part is replaced by a `~~' followed by the name of the directory, but
              only if the result is shorter than the full path; see _D_y_n_a_m_i_c and _S_t_a_t_i_c _n_a_m_e_d _d_i_r_e_c_t_o_r_i_e_s in _z_s_h_e_x_p_n(1).

       %%ee     Evaluation depth of the current sourced file, shell function, or eevvaall.  This is incremented or decremented every time
              the  value  of %%NN is set or reverted to a previous value, respectively.  This is most useful for debugging as part of
              $$PPSS44.

       %%hh
       %%!!     Current history event number.

       %%ii     The line number currently being executed in the script, sourced file, or shell function given by %%NN.   This  is  most
              useful for debugging as part of $$PPSS44.

       %%II     The line number currently being executed in the file %%xx.  This is similar to %%ii, but the line number is always a line
              number in the file where the code was defined, even if the code is a shell function.

       %%jj     The number of jobs.

       %%LL     The current value of $$SSHHLLVVLL.

       %%NN     The name of the script, sourced file, or shell function that zsh is currently executing, whichever was  started  most
              recently.  If there is none, this is equivalent to the parameter $$00.  An integer may follow the `%%' to specify a num‐
              ber of trailing path components to show; zero means the full path.  A negative integer specifies leading components.

       %%xx     The name of the file containing the source code currently being executed.  This behaves as %%NN  except  that  function
              and eval command names are not shown, instead the file where they were defined.

       %%cc
       %%..
       %%CC     Trailing  component  of the current working directory.  An integer may follow the `%%' to get more than one component.
              Unless `%%CC' is used, tilde contraction is performed first.  These are deprecated as %%cc and %%CC are equivalent  to  %%11~~
              and %%11//, respectively, while explicit positive integers have the same effect as for the latter two sequences.

   DDaattee aanndd ttiimmee
       %%DD     The date in _y_y--_m_m--_d_d format.

       %%TT     Current time of day, in 24-hour format.

       %%tt
       %%@@     Current time of day, in 12-hour, am/pm format.

       %%**     Current time of day in 24-hour format, with seconds.

       %%ww     The date in _d_a_y--_d_d format.

       %%WW     The date in _m_m//_d_d//_y_y format.

       %%DD{{_s_t_r_i_n_g}}
              _s_t_r_i_n_g  is  formatted using the ssttrrffttiimmee function.  See _s_t_r_f_t_i_m_e(3) for more details.  Various zsh extensions provide
              numbers with no leading zero or space if the number is a single digit:

              %%ff     a day of the month
              %%KK     the hour of the day on the 24-hour clock
              %%LL     the hour of the day on the 12-hour clock

              In addition, if the system supports the POSIX ggeettttiimmeeooffddaayy system call, %%.. provides decimal  fractions  of  a  second
              since  the  epoch  with leading zeroes.  By default three decimal places are provided, but a number of digits up to 6
              may be given following  the  %%;  hence  %%66..   outputs  microseconds.   A  typical  example  of  this  is  the  format
              `%%DD{{%%HH::%%MM::%%SS..%%..}}'.

              The  GNU extension that a `--' between the %% and the format character causes a leading zero or space to be stripped is
              handled directly by the shell for the format characters dd, ff, HH, kk, ll, mm, MM, SS and yy; any other format characters are
              provided  to the system's strftime(3) with any leading `--' present, so the handling is system dependent.  Further GNU
              (or other) extensions are also passed to strftime(3) and may work if the system supports them.

   VViissuuaall eeffffeeccttss
       %%BB (%%bb)
              Start (stop) boldface mode.

       %%EE     Clear to end of line.

       %%UU (%%uu)
              Start (stop) underline mode.

       %%SS (%%ss)
              Start (stop) standout mode.

       %%FF (%%ff)
              Start (stop) using a different foreground colour, if supported by the terminal.  The  colour  may  be  specified  two
              ways:  either as a numeric argument, as normal, or by a sequence in braces following the %%FF, for example %%FF{{rreedd}}.  In
              the latter case the values allowed are as described for the ffgg zzllee__hhiigghhlliigghhtt attribute; see _C_h_a_r_a_c_t_e_r _H_i_g_h_l_i_g_h_t_i_n_g in
              _z_s_h_z_l_e(1).  This means that numeric colours are allowed in the second format also.

       %%KK (%%kk)
              Start (stop) using a different bacKground colour.  The syntax is identical to that for %%FF and %%ff.

       %%{{...%%}}
              Include  a  string as a literal escape sequence.  The string within the braces should not change the cursor position.
              Brace pairs can nest.

              A positive numeric argument between the %% and the {{ is treated as described for %%GG below.

       %%GG     Within a %%{{...%%}} sequence, include a `glitch': that is, assume that a single character width will be output.  This is
              useful  when  outputting  characters  that  otherwise cannot be correctly handled by the shell, such as the alternate
              character set on some terminals.  The characters in question can be included within a %%{{...%%}} sequence together  with
              the appropriate number of %%GG sequences to indicate the correct width.  An integer between the `%%' and `GG' indicates a
              character width other than one.  Hence %%{{_s_e_q%%22GG%%}} outputs _s_e_q and assumes it takes up the width of two standard char‐
              acters.

              Multiple  uses of %%GG accumulate in the obvious fashion; the position of the %%GG is unimportant.  Negative integers are
              not handled.

              Note that when prompt truncation is in use it is advisable to divide up output into  single  characters  within  each
              %%{{...%%}} group so that the correct truncation point can be found.

CCOONNDDIITTIIOONNAALL SSUUBBSSTTRRIINNGGSS IINN PPRROOMMPPTTSS
       %%vv     The value of the first element of the ppssvvaarr array parameter.  Following the `%%' with an integer gives that element of
              the array.  Negative integers count from the end of the array.

       %%((_x.._t_r_u_e_-_t_e_x_t.._f_a_l_s_e_-_t_e_x_t))
              Specifies a ternary expression.  The character following the _x is arbitrary; the same character is used  to  separate
              the  text  for  the  `true' result from that for the `false' result.  This separator may not appear in the _t_r_u_e_-_t_e_x_t,
              except as part of a %-escape sequence.  A `))' may appear in the _f_a_l_s_e_-_t_e_x_t as `%%))'.   _t_r_u_e_-_t_e_x_t  and  _f_a_l_s_e_-_t_e_x_t  may
              both contain arbitrarily-nested escape sequences, including further ternary expressions.

              The left parenthesis may be preceded or followed by a positive integer _n, which defaults to zero.  A negative integer
              will be multiplied by -1, except as noted below for `ll'.  The test character _x may be any of the following:

              !!      True if the shell is running with privileges.
              ##      True if the effective uid of the current process is _n.
              ??      True if the exit status of the last command was _n.
              __      True if at least _n shell constructs were started.
              CC
              //      True if the current absolute path has at least _n elements relative to the root directory, hence //  is  counted
                     as 0 elements.
              cc
              ..
              ~~      True  if  the  current  path, with prefix replacement, has at least _n elements relative to the root directory,
                     hence // is counted as 0 elements.
              DD      True if the month is equal to _n (January = 0).
              dd      True if the day of the month is equal to _n.
              ee      True if the evaluation depth is at least _n.
              gg      True if the effective gid of the current process is _n.
              jj      True if the number of jobs is at least _n.
              LL      True if the SSHHLLVVLL parameter is at least _n.
              ll      True if at least _n characters have already been printed on the current line.  When _n is negative, true  if  at
                     least aabbss((_n)) characters remain before the opposite margin (thus the left margin for RRPPRROOMMPPTT).
              SS      True if the SSEECCOONNDDSS parameter is at least _n.
              TT      True if the time in hours is equal to _n.
              tt      True if the time in minutes is equal to _n.
              vv      True if the array ppssvvaarr has at least _n elements.
              VV      True if element _n of the array ppssvvaarr is set and non-empty.
              ww      True if the day of the week is equal to _n (Sunday = 0).

       %%<<_s_t_r_i_n_g<<
       %%>>_s_t_r_i_n_g>>
       %%[[_x_s_t_r_i_n_g]]
              Specifies  truncation behaviour for the remainder of the prompt string.  The third, deprecated, form is equivalent to
              `%%_x_s_t_r_i_n_g_x', i.e. _x may be `<<' or `>>'.  The _s_t_r_i_n_g will be displayed in place of the truncated portion of any string;
              note this does not undergo prompt expansion.

              The  numeric  argument, which in the third form may appear immediately after the `[[', specifies the maximum permitted
              length of the various strings that can be displayed in the prompt.  In the first two forms, this numeric argument may
              be negative, in which case the truncation length is determined by subtracting the absolute value of the numeric argu‐
              ment from the number of character positions remaining on the current prompt line.  If this results in a zero or nega‐
              tive  length,  a  length of 1 is used.  In other words, a negative argument arranges that after truncation at least _n
              characters remain before the right margin (left margin for RRPPRROOMMPPTT).

              The forms with `<<' truncate at the left of the string, and the forms with `>>' truncate at the right  of  the  string.
              For  example,  if  the  current  directory is `//hhoommee//ppiikkee', the prompt `%%88<<....<<%%//' will expand to `....ee//ppiikkee'.  In this
              string, the terminating character (`<<', `>>' or `]]'), or in fact any character, may be quoted by a preceding `\\'; note
              when  using  pprriinntt --PP, however, that this must be doubled as the string is also subject to standard pprriinntt processing,
              in addition to any backslashes  removed  by  a  double  quoted  string:   the  worst  case  is  therefore  `pprriinntt  --PP
              ""%%<<\\\\\\\\<<<<......""'.

              If  the _s_t_r_i_n_g is longer than the specified truncation length, it will appear in full, completely replacing the trun‐
              cated string.

              The part of the prompt string to be truncated runs to the end of the string, or to the  end  of  the  next  enclosing
              group  of  the  `%%(('  construct,  or  to the next truncation encountered at the same grouping level (i.e. truncations
              inside a `%%((' are separate), which ever comes first.  In particular, a truncation with argument  zero  (e.g.,  `%%<<<<')
              marks the end of the range of the string to be truncated while turning off truncation from there on. For example, the
              prompt `%%1100<<......<<%%~~%%<<<<%%## ' will print a truncated representation of the current directory, followed by a `%%'  or  `##',
              followed  by a space.  Without the `%%<<<<', those two characters would be included in the string to be truncated.  Note
              that `%%--00<<<<' is not equivalent to `%%<<<<' but specifies that the prompt is truncated at the right margin.

              Truncation applies only within each individual line of the prompt, as delimited by embedded newlines  (if  any).   If
              the  total length of any line of the prompt after truncation is greater than the terminal width, or if the part to be
              truncated contains embedded newlines, truncation behavior is undefined and may change in  a  future  version  of  the
              shell.  Use `%%--_n((ll.._t_r_u_e_-_t_e_x_t.._f_a_l_s_e_-_t_e_x_t))' to remove parts of the prompt when the available space is less than _n.

zsh 5.4.2                                                 August 27, 2017                                                ZSHMISC(1)
