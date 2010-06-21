function [C] = generateBinaryInitialConfigurations(total, sizeOfEach)
% will generate [total] initial configuration each of size [sizeOfEach]
howManyOfEach = total/2;
blackCounter = 0;
whiteCounter = 0;

tot = 0;
while((blackCounter < howManyOfEach || whiteCounter < howManyOfEach) && tot<total)
    a = randint(1, sizeOfEach, [0 1]);
    if(sum(a)>sizeOfEach/2 && blackCounter < howManyOfEach)
        blackCounter = blackCounter +1;
        C(tot+1, :) = a;
        tot = tot+1;
    elseif (sum(a)<sizeOfEach/2 && whiteCounter < howManyOfEach)
        whiteCounter = whiteCounter +1;
        C(tot+1, :) = a;
        tot = tot+1;
    end
end

%test output
%disp([num2str(blackCounter) ' ' num2str(whiteCounter) ' ' num2str(total) ' ' num2str(tot)])

end