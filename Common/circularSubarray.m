function [a] = circularSubarray(A, m, n)

if isempty(A),
    error('circularSubarray: isempty(A)','A is empty') ;
elseif m==n,
    error('circularSubarray: m==n','first and second index are the same') ;
end

N = size(A);
N = N(2);

if m>=1 & n<=N,
    a = A(m:n);
elseif m<1 & n>=1,
    a = [A(N+m:N) A(1:n)];
elseif m<=N & n>N,
    a = [A(m:N) A(1:n-N)];
else
    error('circularSubarray: case not implemented','circular subarray cannot be resolved') ;
end