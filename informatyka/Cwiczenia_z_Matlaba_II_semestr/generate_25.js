const fs = require('fs');

const latexPre = `% ============================================================
%  Baza 25 Zestawów Zaliczeniowych
%  Interpolacja i aproksymacja w MATLAB
% ============================================================
\\documentclass[a4paper,11pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage[polish]{babel}
\\usepackage{geometry}
\\geometry{margin=2.2cm}
\\usepackage{booktabs}
\\usepackage{amsmath}
\\usepackage{parskip}
\\usepackage{titlesec}
\\usepackage{fancyhdr}
\\usepackage{lastpage}
\\usepackage{enumitem}
\\usepackage{mdframed}

\\pagestyle{fancy}
\\fancyhf{}
\\rhead{Interpolacja i aproksymacja -- MATLAB}
\\lhead{Baza Zadań}

\\setlength{\\parindent}{0pt}

\\newmdenv[
  linewidth=0.8pt,
  innerleftmargin=8pt,
  innerrightmargin=8pt,
  innertopmargin=6pt,
  innerbottommargin=6pt
]{ramka}

\\begin{document}
`;

const contexts = [
    ["czas pomiaru", "x", "s", "napięcie", "y", "V"],
    ["czas trwania", "t", "h", "temperatura", "T", "^\\circ\\text{C}"],
    ["odległość", "s", "m", "prędkość", "v", "\\text{m/s}"],
    ["ciśnienie", "p", "\\text{hPa}", "objętość", "V", "\\text{dm}^3"],
    ["temperatura", "T", "\\text{K}", "opór", "R", "\\Omega"],
    ["stężenie", "c", "\\%", "lepkość", "\\eta", "\\text{mPa}\\cdot\\text{s}"],
    ["czas eksperymentu", "t", "\\text{min}", "masa", "m", "g"],
    ["napięcie zasilania", "U", "V", "natężenie", "I", "\\text{mA}"],
    ["kąt nachylenia", "\\alpha", "^\\circ", "siła", "F", "\\text{N}"],
    ["głębokość", "h", "m", "ciśnienie wody", "p", "\\text{kPa}"]
];

const funcs = [
    ["y = e^{-0{,}4x}\\cos(2x)", "y = exp(-0.4*x) .* cos(2*x)", (x) => Math.exp(-0.4*x)*Math.cos(2*x)],
    ["y = 2\\sin(1{,}5x)e^{-0{,}2x}", "y = 2*sin(1.5*x) .* exp(-0.2*x)", (x) => 2*Math.sin(1.5*x)*Math.exp(-0.2*x)],
    ["y = 5\\cos(x)e^{-0{,}1x}", "y = 5*cos(x) .* exp(-0.1*x)", (x) => 5*Math.cos(x)*Math.exp(-0.1*x)],
    ["y = \\frac{10}{1 + x^2}", "y = 10 ./ (1 + x.^2)", (x) => 10 / (1 + x*x)],
    ["y = 3\\sqrt{x}\\ln(x+1)", "y = 3*sqrt(x) .* log(x+1)", (x) => 3*Math.sqrt(x)*Math.log(x+1)],
    ["y = x^2 e^{-0{,}5x}", "y = (x.^2) .* exp(-0.5*x)", (x) => (x*x)*Math.exp(-0.5*x)],
    ["y = 4\\sin(x) + 2\\cos(3x)", "y = 4*sin(x) + 2*cos(3*x)", (x) => 4*Math.sin(x) + 2*Math.cos(3*x)]
];

const interpMethods = ["linear", "spline", "pchip", "nearest"];

const plotStyles = [
    { grid: "Włącz podstawową siatkę (grid on)", points: 200, marker: "kółka ('o')", lineObj: "linią ciągłą w kolorze czerwonym", lineExact: "linią ciągłą czarną", pos: "w lewym górnym rogu ('northwest')" },
    { grid: "Wykres bez siatki (grid off)", points: 300, marker: "gwiazdki ('*')", lineObj: "linią przerywaną w kolorze niebieskim", lineExact: "linią przerywaną szarą", pos: "w najlepszym dopasowanym miejscu ('best')" },
    { grid: "Siatka jest obowiązkowa", points: 150, marker: "kwadraty ('s')", lineObj: "linią kropkowaną czarną", lineExact: "grubą linią zieloną", pos: "w prawym dolnym rogu ('southeast')" },
    { grid: "Zastosuj gęstą siatkę (grid minor)", points: 500, marker: "krzyżyki ('+')", lineObj: "grubą linią magenta", lineExact: "cienką linią czarną", pos: "poza obszarem osi (parametr Location z przyrostkiem 'outside')" },
    { grid: "Dodaj standardową siatkę", points: 250, marker: "romby ('d')", lineObj: "linią ciągłą niebieską", lineExact: "linią ciągłą czerwoną", pos: "w lewym dolnym rogu ('southwest')" }
];

function generateTable(xVals, yVals, xSym, xUnit, ySym, yUnit) {
    const cols = "c|" + "c".repeat(xVals.length);
    const xStr = xVals.map(x => "$" + x.toFixed(1).replace(".", "{,}") + "$").join(" & ");
    const yStr = yVals.map(y => "$" + y.toFixed(3).replace(".", "{,}") + "$").join(" & ");
    
    return `\\begin{center}
\\begin{tabular}{${cols}}
  \\toprule
  $${xSym}$ [$${xUnit}$] & ${xStr} \\\\
  \\midrule
  $${ySym}$ [$${yUnit}$] & ${yStr} \\\\
  \\bottomrule
\\end{tabular}
\\end{center}`;
}

let content = latexPre;

for (let i = 1; i <= 25; i++) {
    content += `\\begin{center}\n  {\\large\\bfseries Zestaw nr ${i} \\quad -- \\quad Interpolacja i aproksymacja}\n\\end{center}\n\\hrulefill\n\\vspace{0.4cm}\n\n`;
    
    const isType1 = (i % 2 !== 0);
    const contextIdx = i % contexts.length;
    const [xName, xSym, xUnit, yName, ySym, yUnit] = contexts[contextIdx];
    
    content += `\\subsection*{Dane}\n\n`;
    
    const nPoints = 5 + (i % 3);
    const xVals = [];
    for(let j=0; j<nPoints; j++) {
        xVals.push(0.5 + j*0.5 + (j%2)*0.1);
    }
    
    if (isType1) {
        const yVals = xVals.map((x, idx) => 2.0 + Math.sin(x)*1.5 + (idx%2)*0.3);
        content += `Dany jest zbiór ${nPoints} punktów pomiarowych (reprezentujących ${xName} $${xSym}$ oraz ${yName} $${ySym}$):\n\n`;
        content += generateTable(xVals, yVals, xSym, xUnit, ySym, yUnit) + "\n\n";
    } else {
        const [latex_f, mat_f, py_f] = funcs[i % funcs.length];
        const latex_f_str = latex_f.replace(/y/g, ySym).replace(/x/g, xSym);
        const yVals = xVals.map(x => py_f(x));
        
        content += `Dane pomiarowe reprezentują ${xName} $${xSym}$ oraz ${yName} $${ySym}$.\n`;
        content += `Dane są generowane z funkcji $${latex_f_str}$ w~${nPoints} rozmieszczonych punktach węzłowych:\n\n`;
        content += generateTable(xVals, yVals, xSym, xUnit, ySym, yUnit) + "\n\n";
        content += `\\medskip\n\\textit{Uwaga:} Wartości w tabeli są przykładowe – skrypt ma generować $${ySym}$ ze wzoru, nie używać gotowych liczb (pamiętaj o operatorze mnożenia tablicowego). Wartości w tabeli mogą się minimalnie różnić od dokładnych wyników funkcji.\n`;
        content += `Wygeneruj wektory $${xSym}$ i~$${ySym}$ bezpośrednio w~skrypcie ze wzoru $${latex_f_str}$.\n\n`;
    }
    
    content += `\\subsection*{Polecenia}\n\n\\begin{enumerate}[leftmargin=*, label=\\textbf{\\arabic*.}, itemsep=2pt]\n\n`;
    
    content += `  \\item \\textbf{Inicjalizacja.}\n    Nazwa pliku: \\texttt{nazwisko\\_imie\\_cw\\_nr}. W komentarzu wewnątrz pliku: zestaw nr: ${i}, wyczyszczenie środowiska, wektory $${xSym}$ i~$${ySym}$.\n\n`;
    
    const wybor_skladnia = (i % 2 === 0) ? "if/else" : "switch/case";
    const deg_approx = 2 + (i % 3);
    const imethod = interpMethods[i % interpMethods.length];
    
    const optionStyles = [
        { a: "1", i: "2", type: "jako liczbę" },
        { a: "10", i: "20", type: "jako liczbę" },
        { a: "a", i: "i", type: "jako tekst" },
        { a: "A", i: "B", type: "jako tekst" },
        { a: "aproksymacja", i: "interpolacja", type: "jako tekst" }
    ];
    const opt = optionStyles[i % optionStyles.length];
    const pOpt = plotStyles[i % plotStyles.length];
    
    if (isType1) {
        content += `  \\item \\textbf{Wybór metody -- \\texttt{${wybor_skladnia}}.}\n    Wyświetl dostępne opcje i~pobierz wybór ${opt.type}: \\textbf{${opt.a}} -- aproksymacja, \\textbf{${opt.i}} -- interpolacja. W podjęciu decyzji użyj struktury \\texttt{${wybor_skladnia}}. Gałąź chwytająca błędy musi wyświetlić komunikat: Błędne dane wejściowe.\n\n`;
        content += `  \\item \\textbf{Aproksymacja.}\n    Poproś użytkownika o podanie wartości zmiennej niezależnej $${xSym}_i$ (użytkownik podaje dowolną wartość $${xSym}_i \\in \\langle ${xVals[0].toFixed(1).replace('.', '{,}')};\\,${xVals[xVals.length-1].toFixed(1).replace('.', '{,}')} \\rangle$). Sprawdź poprawność wprowadzonych danych. Wyznacz wielomian \\textbf{${deg_approx}.~stopnia} metodą najmniejszych kwadratów, oblicz jego wartość w~$${xSym}_i$, zapisz do odpowiedniej zmiennej i~wyświetl wynik w formacie do 4 miejsc po przecinku.\n\n`;
        
        const m1 = interpMethods[(i+1) % interpMethods.length];
        const m2 = interpMethods[(i+2) % interpMethods.length];
        const xi_1 = (xVals[1] + 0.1).toFixed(1).replace('.', '{,}');
        const xi_2 = (xVals[xVals.length-2] - 0.2).toFixed(1).replace('.', '{,}');
        
        const sub1 = opt.type === "jako tekst" ? "1" : "a";
        const sub2 = opt.type === "jako tekst" ? "2" : "b";
        
        content += `  \\item \\textbf{Interpolacja (zagnieżdżony wybór).}\n    Jeżeli użytkownik wybrał interpolację, użyj zagnieżdżonej instrukcji warunkowej w celu dopytania szczegółów. Sprawdź poprawność wyboru. Daj wybór opcji:\n`;
        content += `    \\begin{itemize}[itemsep=1pt]\n`;
        content += `      \\item \\textbf{${sub1}} -- interpolacja przedziałowa '${m1}' w~$${xSym}_i = ${xi_1}$ (użyj \\texttt{interp1(..., '${m1}')}); zapisz do zmiennej i~wyświetl wynik do 4 miejsc po przecinku.\n`;
        content += `      \\item \\textbf{${sub2}} -- interpolacja metoda '${m2}'; oblicz wartość w~$${xSym}_i = ${xi_2}$, zapisz wynik i~wyświetl w formacie do 4 miejsc po przecinku.\n`;
        content += `      \\item \\textbf{błąd} -- wyświetl komunikat: Błędne dane wejściowe.\n    \\end{itemize}\n\n`;
        content += `  \\item \\textbf{Wykres.}\n    Dla wybranej przez użytkownika metody utwórz gęsty wektor $${xSym}_p \\in \\langle ${xVals[0].toFixed(1).replace('.', '{,}')};\\,${xVals[xVals.length-1].toFixed(1).replace('.', '{,}')} \\rangle$ (${pOpt.points} punktów). Oblicz na nim wartości wyznaczonej krzywej. W przypadku interpolacji rysowana jest krzywa dla ostatecznie wybranej metody. Narysuj ją ${pOpt.lineObj}, a punkty pomiarowe oznacz jako ${pOpt.marker}. Opcjonalnie dodaj merytoryczne podpisy osi, tytuł i odpowiednio ułożoną legendę (${pOpt.pos}). ${pOpt.grid}.\n\n`;
    } else {
        content += `  \\item \\textbf{Wybór metody -- \\texttt{${wybor_skladnia}}.}\n    Wyświetl dostępne opcje i~pobierz wybór ${opt.type}: \\textbf{${opt.a}} -- aproksymacja wielomianem ${deg_approx}.~stopnia, \\textbf{${opt.i}} -- interpolacja '${imethod}'. Wariant błędny musi po prostu wyświetlać komunikat: Błędne dane wejściowe.\n\n`;
        const t_apx = ((xVals[1] + xVals[2])/2).toFixed(2).replace('.', '{,}');
        content += `  \\item \\textbf{Aproksymacja.}\n    Wyznacz wielomian \\textbf{${deg_approx}.~stopnia} metodą najmniejszych kwadratów. Oblicz jego wartość w~$${xSym}_i = ${t_apx}$, zapisz wynik do zmiennej i~wyświetl (np. z dokładnością do 4 miejsc po przecinku).\n\n`;
        const t_int = ((xVals[0] + xVals[1])/2).toFixed(2).replace('.', '{,}');
        content += `  \\item \\textbf{Interpolacja.}\n    Wyznacz wartość interpolowaną w~$${xSym}_i = ${t_int}$ metodą '${imethod}'. Zapisz i wyświetl wynik w odpowiednim formacie (np. 4 miejsca po przecinku) oraz \\textbf{błąd bezwzględny} względem wartości dokładnej.\n\n`;
        content += `  \\item \\textbf{Wykres.}\n    Dla wybranej przez użytkownika metody utwórz gęsty wektor reprezentujący przedział pomiarowy (${pOpt.points} badanych punktów). Narysuj na jednym wykresie wykreowane elementy: wyznaczoną w poprzednich krokach krzywą (zależnie od wyboru -- tylko aproksymacyjną albo tylko interpolacyjną) ukazaną ${pOpt.lineObj}, funkcję dokładną narysowaną ${pOpt.lineExact} oraz zbiór punktów eksperymentalnych ujętych jako ${pOpt.marker}. Opcjonalnie dodaj merytoryczne podpisy osi, tytuł i~legendę (${pOpt.pos}). ${pOpt.grid}.\n\n`;
    }
    
    content += `\\end{enumerate}\n\n`;
    content += `\\vspace{0.3cm}\n\\begin{ramka}\n\\textbf{Wymagane konstrukcje:}\n`;
    content += `\\texttt{${wybor_skladnia}}, \\texttt{disp}, \\texttt{input}, \\texttt{polyfit}, \\texttt{polyval}, \\texttt{interp1}, \\texttt{plot}.\n`;
    content += `\\end{ramka}\n\n`;
    
    if (i < 25) {
        content += `\\clearpage\n`;
    }
}

content += `\\end{document}\n`;

fs.writeFileSync('c:/Users/szymo/Desktop/Informatyka/Ćwiczenia z Matlaba II semestr/zestawy_25.tex', content, 'utf8');
console.log('Gotowe!');
