% Time-Stamp: <2023-11-04 13:35:08>
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{MishoLetter}[2023/11/03 Sho Iwamoto]

\let\@classoptionslist@old\@classoptionslist
\edef\@classoptionslist{\@classoptionslist@old,12pt,final,pdfa}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{MishoNote}}
\ProcessOptions\relax
\LoadClass[12pt,pdfa,lastpage]{MishoNote}

\usetikzlibrary{positioning}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\tikzstyle{RightTitleBox} = [xshift=-25mm,yshift=-30mm,anchor=north east,inner sep=0pt,outer sep=0pt]

\renewcommand\maketitle{
  \thispagestyle{empty}%
  \begin{tikzpicture}[remember picture,overlay,text width=\textwidth]%
    % 日本語は日付/宛先/差出人
    % 英語は差出人/日付/宛先
    \ifmisho@japanese%
%    \begin{textblock}{300}[1,0](453,3)%
%      \hfill\@date\par%
%      {\fontsize{10}{12}\selectfont{\TITLELINES}}\par%
%    \end{textblock}%
%    \begin{textblock}{360}(10,0)%
%      \vspace{\baselineskip}\noindent\RECIPIENT%
%    \end{textblock}%
    \else%
    \node[RightTitleBox] at (current page.north east) (rtb) {\fontsize{10}{12}\selectfont\flushright\TITLELINES\par\vspace{\baselineskip}\@date\par\endflushright};%
      \node[below=\baselineskip of rtb] (rcp) {\noindent\RECIPIENT};
    \fi
  \end{tikzpicture}\relax%
  \vspace{30mm}\par
}%

\newenvironment{Signature}{\hfill\begin{tabular}{l@{}}\hspace*{-1em}Best regards,\\}{\end{tabular}}

\def\HEADLINE{\@title~~~\@date~~~}
\def\head@hrule{\relax}
\def\head@h{\relax}
\def\head@j{\HEADLINE}
\def\head@p{Page~\thepage~of~\NoHyper\pageref{LastPage}\endNoHyper\kern-2mm}
\def\head@jstyle{\fontsize{9}{12}\selectfont\sffamily\itshape}
\def\head@pstyle{\fontsize{9}{12}\selectfont\sffamily\itshape}


%-------------------------------------------------------------------------------
\newcommand\MAILTO[2][\tt]{\href{mailto:#2}{#1#2}}
\newcommand\TEL[2][\tt]{\href{tel:#2}{#1#2}}
\newcommand\ELTE{ELTE E\"otv\"os Lor\'and University\xspace}
\newcommand\NSYSU{National Sun Yat-sen University\xspace}
\newcommand\SHO{Sho Iwamoto\xspace}
\newcommand\KOICHI{Koichi Hamaguchi\xspace}
\newcommand\YAEL{Yael Shadmi\xspace}
\newcommand\ZOLTAN{Zolt\'an Tr\'ocs\'anyi\xspace}
%-------------------------------------------------------------------------------

