function output = ldpc_coder(ficello, taille); %ficelle est notre string mais string m etait refus� :'( et en fr string = ficelle
% H = [1 0 0 0 0 1 0 1 0 1 0 0;
% 1 0 0 1 1 0 0 0 0 0 1 0;
% 0 1 0 0 1 0 1 0 1 0 0 0;
% 0 0 1 0 0 1 0 0 0 0 1 1;
% 0 0 1 0 0 0 1 1 0 0 0 1;
% 0 1 0 0 1 0 0 0 1 0 1 0;
% 1 0 0 1 0 0 1 0 0 1 0 0;
% 0 1 0 0 0 1 0 1 0 1 0 0;
% 0 0 1 1 0 0 0 0 1 0 0 1];

H = [0 1 0 1 1 0 0 1;
     1 1 1 0 0 1 0 0;
     0 0 1 0 0 1 1 1;
     1 0 0 1 1 0 1 0];
 
% H = [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%  0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0;
%  0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0;
%  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1;
%  1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1;
%  0 1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0;
%  0 0 0 1 0 1 1 0 1 0 0 0 0 0 1 0 0 0 0 0 0;
%  0 0 0 0 1 0 0 0 0 1 0 0 1 1 0 1 0 0 0 1 0;
%  0 1 0 0 1 0 1 1 1 0 0 0 0 1 0 0 0 0 0 0 0;
%  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 1;
%  0 0 0 1 0 0 0 0 0 0 1 1 1 0 0 0 0 0 1 1 0;
%  0 0 1 0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0;
%  1 0 1 0 0 0 0 1 0 1 0 0 0 1 0 0 0 0 0 0 0;
%  0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 1 0 1 0 0;
%  0 0 0 0 0 1 1 0 1 0 0 0 1 0 0 0 0 1 0 1 0;
%  0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 1];
 
G = mod(gen2par(rref(H)),2) %g�n�re la matrice G � partir de H
row=size(G,1)%obtient le nombre de ligne de la matrice G, requise pour l encodage.
encodedmsg = [];%cr�� une matrice pour concat�ner tout les symboles dans une seule matrice
taille
((taille/row)-2)
for k=0:((taille/row)-2) %nombre d iteration = nombre de caracteres
 symboles=mod(ficello(1,k*row+1:k*row+row)*G,2)%cr�� les symboles
 encodedmsg = horzcat(encodedmsg,symboles); %concatene les symboles dans une seule et meme matrice
end
%mod(H*transpose(encodedmsg),2) %permet de verifier la validit� des mots
%code cr��s.

output=encodedmsg
end