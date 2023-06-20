import numpy as np
import time
import fsSLEP

def matPrimal(A,Y,Lambda,**kwargs):
    B = np.copy(Y)

    if 'prn' not in kwargs.keys():
        kwargs['prn'] = 1
    optprn = kwargs['prn']

    if 'tol' not in kwargs.keys():
        kwargs['tol'] = 1e-3
    tol = kwargs['tol']

    if 'freq' not in kwargs.keys():
        kwargs['freq'] = 10
    freq = kwargs['freq']

    if 'max_itr' not in kwargs.keys():
        kwargs['max_itr'] = 1e6
    maxiter = kwargs['max_itr']

    A = (1/np.sqrt(Lambda))*A
    B = (1/np.sqrt(Lambda))*B

    n=np.shape(A)[1]
    m=1
    p=np.shape(B)[0]
    if optprn == 1:
        print(' m,n,p = {:d},{:d},{:d}'.format(m,n,p))
    meps=1e-10
    iter=0

    # check if A has full row rank
    reduce_flag=1
    if p>=n: 
      r=np.linalg.matrix_rank(A)        # rank is expensive, do this only if needed
      if r==n: 
        reduce_flag=0

    # If A lacks full row rank, reduce A to "upper triangular".  
    if reduce_flag==1:
      if optprn == 1:
          print(' reduce A to have full row rank:')
      Time = time.time()
      R0,S0,E0 = fsSLEP.qr(A.T)
      r=np.linalg.matrix_rank(S0)
      Anew=S0[0:r,:].T
      Bnew=E0.T.dot(B)
      t_rA=time.time() - Time
      if optprn == 1:
        print(' done reducing A, time: {:f}'.format(t_rA))
    else:
      r=n
      t_rA=0
     
    # From now on, the n in the code and in the description corresponds to the
    # rank of Anew, i.e., r.
    Time = time.time()

    if reduce_flag==1:
      M=Anew.T.dot(Anew)
      M2=Anew.T.dot(Bnew)
      m3=fsSLEP.mytrace(Bnew,Bnew)
    #  C=inv(M)
    #  E=Bnew.T*Anew*C
    else:
      M=A.T.dot(A)
      M2=A.T.dot(B)
      m3=fsSLEP.mytrace(B,B)
    #  C=inv(M)
    #  E=B.T*A*C

    C=np.linalg.inv(M)
    E=M2.T.dot(C)
    f=fsSLEP.mytrace(M2.dot(M2.T),C)-m3

    t3=Time - time.time()
    if optprn == 1:
        print(' done computing C and E, time: {:f}'.format(t3))

    Time = time.time()
    # Initialize W
    W=E.T
    #W=C*M2      #This least-square init yields comparable performance as W=E'.
    #W=zeros(r,m)    #This yields much slower convergence.
    W0=np.copy(W)

    theta=1
    theta0=1

    L = max(np.linalg.eigvals(M))
    #L=norm(M)        #slower than eigs(M,1)
    if optprn == 1:
        print(' L = {:f}, tol = {:f}, freq = {:f}'.format(L, tol, freq))

    while iter<=maxiter:
      
      iter=iter+1

      Y=W+theta*(1/theta0-1)*(W-W0)
      G=M.dot(Y)-M2
      T=Y-G/L
      R,D,S=np.linalg.svd(T,full_matrices=False) # T=R*D*S.T This and the following line compute
                               # the minimizer to step 2 of accel. grad.
                               # algorithm.
      W0=np.copy(W)
      shapy = np.shape(D)[0]
      W=R.dot(np.max((D-np.eye(shapy)/L,np.zeros((shapy,shapy))))).dot(S.T)
    #  W=R*diag(max(diag(D)-1/L,0))*S.T
    #  W=R*diag(median([diag(D)+1/L,diag(D)-1/L,zeros(min(m,n),1)].T))*S.T

      if np.linalg.norm(W-W0,'fro')<=meps:
        if optprn == 1:
            print(' termination due to negligible change in U = {:f}'.format(np.linalg.norm(W-W0,'fro')))
        U=(W.T-E).dot(M)
        R,D,S=np.linalg.svd(U,full_matrices=False)
        shapy = np.shape(D)[0]
        D = np.reshape(D, (shapy,1))
        U=R * np.min((D,np.zeros((shapy,shapy)))) * S.T         #Project to make U dual feasible
        temp1, temp2, temp3 = np.linalg.svd(W,full_matrices=False)
        pobj=(fsSLEP.mytrace(W,M.dot(W))-2*fsSLEP.mytrace(M2,W)+m3)/2+np.sum(temp1)
        dobj=-fsSLEP.mytrace(U.T.dot(C),U)/2 - fsSLEP.mytrace(E,U)-f/2
        if optprn == 1:
            print(' iter= {:f}  dobj= {:f}  pobj= {:f}'.format(iter,dobj,pobj))
        break
      
      theta0=theta
      theta=(np.sqrt(theta**4+4*theta**2)-theta**2)/2 # Update theta
      iter=iter+1

      # Compute the gradient of the smooth part
      if (iter>0) and (iter % freq == 0):
        U=(W.T-E).dot(M)
        R,D,S=np.linalg.svd(U,full_matrices=False)
        U=R.dot(np.min((D,np.ones(np.shape(D))))).dot(S.T)        #Project to make U dual feasible
        temp1, temp2, temp3 = np.linalg.svd(W,full_matrices=False)
        pobj=(fsSLEP.mytrace(W,M.dot(W))-2*fsSLEP.mytrace(M2,W)+m3)/2+np.sum(temp1)
        dobj=-fsSLEP.mytrace(U.dot(C),U)/2 - fsSLEP.mytrace(E,U)-f/2
        if optprn == 1:
            print(' iter= {:f}  dobj= {:f}  pobj= {:f}'.format(iter,dobj,pobj))
        if abs(pobj-dobj) < tol*(abs(dobj)+1):
          break

    t1=time.time() - Time
    if reduce_flag==1:
      W=R0.T.dot(np.vstack((W, np.zeros((n-r,m)))))
    if optprn == 1:
        print(' iter = {:f}, fmin = {:f}, total time = {:f}'.format(iter, pobj, t1+t3+t_rA))

    return W, pobj
