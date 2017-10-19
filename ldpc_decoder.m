%main funciton
% the input frame length must match the number of columns of H
function output = ldpc_decoder(frame, taille)


success = 0; % decoding stopping condition
max_iterations = 100; 
current_iteration = 0;


input_frame = frame;%we store the frame which was on input
current_frame = frame;%we initialize the frame on which we will work


% La matrice H, qui contient 12 v_nodes et 9 c_nodes.
% Chaque v_node est gere par 3 c_nodes.
% Chaque c_node gere 4 v_nodes.
% It is possible to put another legit matrix here, the code will adapt
H = [1 0 0 0 0 1 0 1 0 1 0 0; 
     1 0 0 1 1 0 0 0 0 0 1 0;
     0 1 0 0 1 0 1 0 1 0 0 0;
     0 0 1 0 0 1 0 0 0 0 1 1;
     0 0 1 0 0 0 1 1 0 0 0 1;
     0 1 0 0 1 0 0 0 1 0 1 0;
     1 0 0 1 0 0 1 0 0 1 0 0;
     0 1 0 0 0 1 0 1 0 1 0 0;
     0 0 1 1 0 0 0 0 1 0 0 1]; 
 
nb_c_nodes = size(H,1); % the number of c_nodes (= number of rows)
nb_v_nodes = size(H,2); % the number of v_nodes (= number of columns)
c_per_v = get_c_per_v(H, nb_v_nodes); % number of c_nodes concerned by a v_node 

%--------- error checking  -------------
isErrorsPresent = check_errors(H, input_frame);
if isErrorsPresent == 0
    success = 1;
end

%-------- DECODE LOOP ---------------
while success==0 && current_iteration<max_iterations
    
    current_iteration = current_iteration + 1;
    flip_counter = zeros([1 nb_v_nodes]); % create an array of the size of v_nodes, and will count the number of votes for v_nodes flipping
    
    for  i= 1:1:(nb_c_nodes) %iterate each row of the matrix, because 1 row = 1 parity check
        
        %---------- PARITY CHECK OPERATIONS ---------------
        % for each c_node, we check the parity of concerned bits
        % if the parity check failed, we will add in the array flip_counter
        % that the c_node want to flip a bit value
        isBitFlippingRequired = check_parity(H(i,:),current_frame);
        if isBitFlippingRequired == 0
            flip_counter = bitFlipVote(H(i,:), flip_counter);
        end
    end
    
    %---------- VOTE OPERATIONS -------------------------
    % we check if there is a majority of votes to flip the bit for each
    % bit, and if so, we update the current_frame
    current_frame = vote_and_flip(current_frame, flip_counter, c_per_v);
   
    
    %----------- ERROR CHECK -------------
    isErrorsPresent = check_errors(H, current_frame);
    if isErrorsPresent == 0
        success = 1;
    else 
        disp("still errors at loop n° " +current_iteration);
        disp("current frame : ");
        disp(current_frame);
    end
    
end
    %transpose(current_frame)
    G = mod(gen2par(rref(H)),2);
    decoded_msg = [];
    row=size(G,1);
    %for k=0:row
    %    decodedmsg = mod(current_frame(k*row+1:k*row+row,1)*G,2)%créé les symboles
    %    decoded_msg = horzcat(decoded_msg,decodedmsg);
    %end
    
    for k=0:((taille/row)-2) %nombre d iteration = nombre de caracteres
        symboles=mod(current_frame(1,k*row+1:k*row+row)/G,2);%créé les symboles
        decoded_msg = horzcat(decoded_msg,symboles); %concatene les symboles dans une seule et meme matrice
    end

end


%------------- OTHER FUNCTIONS -----------


% return 1 if the parity is OK for the bits of curent_frame which are
% monitored by the H_row in parameter.
% return 0 if parity NOK
% H_row contains the bits index which are monitored by the c_node H_row is
% associated with
function res = check_parity(H_row, current_frame)
    res = 0;
    
    mult_res = H_row * transpose(current_frame); %to get the parity check on the concerned bit, we multiply those 2 vectors
    
    if mod(mult_res, 2) == 0
        res = 1;
    end
end

% will add a vote in the counter to flip bits concerned by a c_node
% return the updated counter
function counter = bitFlipVote(H_row, flip_counter)
   for i= 1:1:size(H_row,2)
      if  H_row(i) == 1
          flip_counter(i) = flip_counter(i) +1;
      end
   end
   counter = flip_counter;
    
    
end

%get the number of c_nodes per v_nodes
% return this number
function res = get_c_per_v(H, nb_v_nodes)
    tmp = transpose(H);
    res= sum(tmp(nb_v_nodes,:)==1);
end

%by passing the current frame, the votes and the number of voters, this
%function will flip the wrong bits and will return the new frame
function res_frame = vote_and_flip(current_frame, flip_counter, c_per_v)
    for i= 1:1:size(flip_counter,2)
       
        if flip_counter(i) > ((c_per_v + 1)/2) %if the number of votes have the majority (half of the number of voters + current bit)
            current_frame(i) = 1 - current_frame(i);
        end
    end
    
    res_frame = current_frame;
end

%return 1 if there's errors in the frame
% return 0 if not
function res = check_errors(H, current_frame)

    syndrome =  H * transpose(current_frame); % syndrome = H * v^t
    isErrors = any(mod(syndrome,2)); %  if there's something else than 0 in the syndrome, ERROR detected
    
    res = isErrors;
end