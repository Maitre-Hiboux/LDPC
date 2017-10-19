function main(ficelle); %ficelle est notre string mais string m etait refus� :'( et en fr string = ficelle
ficelle;
H = [1 0 0 0 0 1 0 1 0 1 0 0;
     1 0 0 1 1 0 0 0 0 0 1 0;
     0 1 0 0 1 0 1 0 1 0 0 0;
     0 0 1 0 0 1 0 0 0 0 1 1;
     0 0 1 0 0 0 1 1 0 0 0 1;
     0 1 0 0 1 0 0 0 1 0 1 0;
     1 0 0 1 0 0 1 0 0 1 0 0;
     0 1 0 0 0 1 0 1 0 1 0 0;
     0 0 1 1 0 0 0 0 1 0 0 1];
 
 G = gen2par(rref(H)); %g�n�re la matrice G � partir de H

ficelleb = reshape(dec2bin(ficelle,7)',1,[]);%converti les cracteres ascii en tableaux binaires
% le <'> apr�s le dec2bin() sert � transposer la matrice
for k=1:size(ficelleb,2)
    ficello(1,k) = str2num(ficelleb(1,k));%transforme le tableau ficelleb em matrice
end

% transformer la matrice ficello en caractere ascii
for k=0:((size(ficelleb,2)/7)-1)
    convertedvalue = char(bin2dec(num2str(ficello(1,k*7+1:k*7+7))));%num2str() transforme la matrice en string, bin2dec() transforme la string de valeur binaire en un valeur numerique, char() converti la valeur numerique en charactere ascii.
end
% fin transformation
G=mod(G,2);%rend la matrice binaire
row=size(G,1);%obtient le nombre de ligne de la matrice G, requise pour l encodage.
encodedmsg = [];%cr�� une matrice pour concat�ner tout les symboles dans une seule matrice
for k=0:((size(ficelleb,2)/row)-2) %nombre d iteration = nombre de caracteres
    symboles=mod(ficello(1,k*row+1:k*row+row)*G,2);%cr�� les symboles
    encodedmsg = horzcat(encodedmsg,symboles); %concatene les symboles dans une seule et meme matrice
end
%mod(H*transpose(encodedmsg),2) %permet de verifier la validit� des mots
%code cr��s.

encodedmsg
end