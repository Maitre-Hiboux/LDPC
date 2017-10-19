function main(message);

ficelleb = reshape(dec2bin(message,7)',1,[]);%converti les cracteres ascii en tableaux binaires
% le <'> après le dec2bin() sert à transposer la matrice
for k=1:size(ficelleb,2)
    ficello(1,k) = str2num(ficelleb(1,k));%transforme le tableau ficelleb em matrice
end
taille = (size(ficelleb,2));

encoded_msg = ldpc_coder(ficello, taille)

% decoded_msg = ldpc_decoder(encoded_msg, taille);
% % transformer la matrice ficello en caractere ascii
% for k=0:((size(ficelleb,2)/7)-1)
%     convertedvalue = char(bin2dec(num2str(decoded_msg(1,k*7+1:k*7+7))));%num2str() transforme la matrice en string, bin2dec() transforme la string de valeur binaire en un valeur numerique, char() converti la valeur numerique en charactere ascii.
% end
% % fin transformation
% 
% disp(convertedvalue);