  function [x,opts,v,H,status] = sqp_MODIF(Fun,x0,Opts,vlb,vub,Grd,varargin)
% SQP    Schittkowski's Sequential Quadratic Programming method
%        to find the constrained minimum of a function of several variables
% Find the minimum of a constrained nonlinear multivariable function,
%    min          f (x )    
%    such that    g (x ) <= 0
%                 x E R^n
% Copyright (c) 2015, Robert A. Canfield, Mark Spillman. All rights reserved.
%                     See accompanying LICENSE.txt file for conditions.
% Schittkowski (1985) "NLPQL: A FORTRAN Subroutine Solving Constrained 
% Nonlinear Programming Problems," Annals Ops. Research, 5:485-500.
% Optimization Toolbox Version 1-compatible input arguments:
% usage: [x,opts,v,H,status]=sqp(Fun,x0,Opts,vlb,vub,Grd,P1,P2,...)
%   OPTIONS = FOPTIONS returns the default options.
%  input: Fun    - string name of a function file which returns the
%                  value of the objective function and a vector of
%                  constraints (i.e. [f,g] = fun(x)).  f is minimized
%                  such that g < zeros(g). Set g = [] for unconstrained.
%         x0     - initial vector of design variables
%         Opts   - (optional) vector of program parameters, or optimset structure
%                  opts(5)  - scale design variables if < 0  (or opts.scale)
%                             scale functions if f,g > abs(opts(5))
%                  opts(6)  - change termination criteria  
%                             (or opts.termination)
%                  opts(7)  - maximum function evaluations in line search 
%                             (or opts.MaxLineSearchFun)
%                  opts(14) - max number of function evaluations
%                  opts(15) - max iterations
%                  Type help foptions for more details.
%              Or, a structure following the new fmincon options (optimset)
%                  In addition to optimset options, Opts may contain:
%                  opts.foptions - vector (<=18 length) of old style foptions
%                  opts.LagrangeMultipliers - initial Lagrange multiplier estimate
%                  opts.HessMatrix          - initial positive-definite Hessian estimate
%                  opts.HessFun             - user-supplied Hessian function handle
%                       H=Hessian(x,LagrangeMultipliers)
%         vlb    - (optional) vector of lower bounds on the design
%                  variables
%         vub    - (optional) vector of upper bounds on the design
%                  variables
%         Grd    - (optional) string name of a function file which
%                  returns a vector of function gradients and a
%                  matrix of constraint gradients
%                  (i.e. [fp,gp]=grd(x)).
%         Pn     - (optional) variables directly passed to fun and grd
%                  optional inputs Pn can be skipped by inputing []
%
%  output: x      - vector of design variables at the optimal solution
%          opts   - final program parameters
%                   opts(8)  = value of the function at the solution
%                   opts(10) = number of function evaluations
%                   opts(11) = number of gradient evaluations
%                   opts(15) = number of iterations
%          v      - vector of Lagrange multipliers at the solution
%          H      - Hessian at the solution
%          status - Termination status: 0=converged
%
%  fmincon-compatible problem structure input argument
%          optimtool GUI option "Export to Workspace" dialog box 
%          sends problem information to the MATLAB workspace as a structure
%          usage: [x,opts,v,H,status] = sqp( problem )
%          input: problem - Data structure with fields:
%                 objective - Objective function
%                 x0        - Initial point for x
%                 Aineq     - Matrix for linear inequality constraints
%                 bineq     - Vector for linear inequality constraints
%                 Aeq       - Matrix for linear equality constraints
%                 beq       - Vector for linear equality constraints
%                 lb        - Vector of lower bounds
%                 ub        - Vector of upper bounds
%                 nonlcon   - Nonlinear constraint function
%                 options   - Options created with optimset
%  Written by:   Capt Mark Spillman and Maj Robert A. Canfield
%                Air Force Institute of Technology, Virginia Tech
% The function format is based on the MATLAB function constr.m written
% by Andy Grace of MathWorks, 7/90.  The algorithm is based the FORTRAN
% routine NLPQL written by Klaus Schittkowski, 6/91.
% ---------------------------------------------------------------------
% Explain the different possible termination criteria
% Three different termination criterias can be selected with opts(6):
% 1.  If opts(6) = (-1), Schittkowski's criteria is used:
%        KTO = abs(s'*fp) + sum(abs(u.*gv)) <= opts(3)
%                         SCV = sum(g(g>0)) <= sqrt(opts(3))
%
% 2.  If opts(6) = 1, Andy Grace's criteria is used:
%                     ms = .5*max(abs(s)) <   opts(2)
%                     AG = .5*abs(fp'*s)  <   opts(3)
%                                max(g)   <   opts(4)
%  
% 3.  If opts(6) ~= (-1) & opts(6) ~= 1, the default criteria is used:
%                          max(abs(dx))  <=  opts(2)
%                                   KTO  <=  opts(3)
%                                max(g)  <=  opts(4)
%
% 4.  If opts(6) == 2, add Slowed convergence criterion to (3) above.
%                    KTO = norm(Lagrangian gradient)
% ---------------------------------------------------------------------
% Explain trouble shooting information
% If opts(1) = 2 the following information will also be displayed
% when applicable:
%     'dH' - Hessian has been perturbed for improved conditioning
%     'aS' - The augmented Lagrangian type Search direction was used
%     'mS' - The modified Search direction problem was used
%     'sx' - Design variables are being scaled
%     'sf' - Objective function is being scaled
%     'sg' - One or more constraint functions scaled
% --------------------------------------------------------------------------
% Internal sub-function interfaces
% MERIT       Merit Function for one-dimensional search
% usage:      [z0,z0p1,z0p2,z0p3] = merit(v,r,nec,f,g,fp,gp,u,s)
% inputs:     v     - Estimates of the optimal Lagrange multipliers
%             r     - scalar penalty parameter
%             nec   - number of equality constraints
%             f     - function value
%             g     - constraint values
%             fp    - (required for z0p1-3) function gradient
%             gp    - (required for z0p1-3) constraint gradients
%             u     - (required for z0p1-3) Lagrange multipliers
%                     for QP search direction problem
%             s     - (required for z0p1-3) search direction
% outputs:    z0    - value of the merit function at alpha
%             z0p1  - derivative of the merit function wrt alpha
%             z0p2  - derivative of the merit function wrt x
%             z0p3  - derivative of the merit function wrt v
%
% SQPFDGRD    SQP Finite Difference Gradients
% usage:      [df,dg] = sqpfdgrd(fcnstr, x0, f0, g0, xmin, xmax, x1,P1,...,P15)
% inputs:     fcnstr     - function evaluation call in string form for 'eval'
%             x0         - current design variable vector
%             f0         - objective value at x0
%             g0         - constraint values at x0
%             xmin       - minimum finite difference step
%             xmax       - maximum finite difference step
%             x1         - scale factor for design variables
%             Pn         - optional variables directly passed to fcnstr
% outputs:    df         - finite difference objective gradient vector
%             dg         - finite difference constraint gradients matrix
%
% GRADERR     Gradient Error print routine (MATLAB optim Toolobox)
% usage:      graderr( FDgrad, grad, str )
% inputs:     FDgrad    - Finite Difference gradient(s)
%             grad      - Analytic gradient(s)
%             str       - String used to evaluate FDgrad
%
% QP          Quadratic Programming solver (MATLAB optim Toolbox)
% usage:      [s,u,status] = qp(H,fp,A,b,vlb,vub,x0,neq,nomsg)
% inputs:     H        - Quadratic coefficient matrix (Hessian)
%             fp       - Linear constant vector (function gradient)
%             A        - Constraint coefficient matrix
%             b        - Constraint constants
%             vlb,vub  - Variable lower and upper bounds
%             neq      - Number of equality constraints
%             n0msg    - Flag to turn off messages
% outputs:    s        - Optimal search direction
%             u        - Lagrange multipliers
%             status   - Termination status
% ---------------------------------------------------------------------
% Modifications Implement active constraint strategy
% ---------------------------------------------------------------------
  global ACTIVE_CONSTRAINTS 
% Process options
  ndv = length(x0(:));

% Check lower and upper bounds: vlb and vub
  lenvlb = 0; ilb = [];
  lenvub = 0; iub = [];

% Read input options vector or structure
% ================== ########01-11-2017######## =================
% ================== ################ =================
% Read input options vector or structure
% [opts,v,H,ComplexStep] = sqpcrkopts(Opts,ndv);
% tolcon = opts(4)
  opts( 1) = 2 ; % or 0;         % 1)-Display parameter (Default:0). 1 displays some results.                       
  opts( 2) = 1e-3;               % 2)-Termination tolerance for X.(Default: 1e-4).                                  
  opts( 3) = 1e-4;               % 3)-Termination tolerance on F.(Default: 1e-4).                                   
  opts( 4) = 1e-6;               % 4)-Termination criterion on constraint violation.(Default: 1e-6)                 
  opts( 5) = 0;                  % 5)-Algorithm: Strategy:  Not always used.                                        
  opts( 6) = -1 ; % 0 or 1;      % 6)-Algorithm: Optimizer: Not always used.                                        
  opts( 7) = 0;                  % 7)-Algorithm: Line Search Algorithm. (Default 0)                                 
  opts( 8) = 0;                  % 8)-Function value. (Lambda in goal attainment. )                                 
  opts( 9) = 1;                  % 9)-Set to 1 if you want to check user-supplied gradients                         
  opts(10) = 0;                  % 10)-Number of Function and Constraint Evaluations.                               
  opts(11) = 0 ;                 % 11)-Number of Function Gradient Evaluations.                                     
  opts(12) = 0;                  % 12)-Number of Constraint Evaluations.                                            
  opts(13) = 0; % opts(13)= nec; % 13)-Number of equality constraints.                                              
  opts(14) = Opts.MaxIter;       % 14)-Maximum number of function evaluations. (Default is 100*number of variables) 
  opts(15) = 500;                % 15)-Used in goal attainment for special objectives.                              
  opts(16) = 1e-08 ; % or 0;     % 16)-Minimum change in variables for finite difference gradients.                 
  opts(17) = Inf;                % 17)-Maximum change in variables for finite difference gradients.                 
  opts(18) = 0;                  % 18)-Step length. (Default 1 or less).                                            
  v = [];
  H = [];
  ComplexStep = 1;
  x = x0;
  nec = opts(13);
% ================== ####### end 01-11-2017######### =================
% ================== ################ =================
% scdv = opts(5) < 0; scbou = abs(opts(5));
  scdv = 0;
  scbou = 0;
  nlinmax = 15;
      
% UserHessian = isfield(Opts,'HessFun') && ~isempty(Opts.HessFun);
  UserHessian = 0; 
  trouble = '';
  UpdHess = []; 

% Scale design variables and bounds
  if scdv
     x1 = x;
     x  = ones(size(x));
     for i = find(abs(x1) < 1e-3)
         x1(i) = ones(size(i));
         x(i)  = x0(i);
     end;
     if lenvlb
        vlb(ilb) = vlb(ilb)./x1(ilb);
     end
     if lenvub
        vub(iub) = vub(iub)./x1(iub);
     end
     trouble = ' sx ';
  else
     x1 = [];
  end

% Set up function and gradient calls with design variable scaling for x.
  if all(size(x) == size(x0))
     xshape = @(x) x;
  end

% -------------------------------------------------------------
% Fun    - string name of a function file which returns the
%          value of the objective function and a vector of
%          constraints (i.e. [f,g] = fun(x)).  f is minimized
%          such that g < zeros(g). Set g = [] for unconstrained.
% fun = @(x) feval(Fun,xshape(x),varargin{:});

% ------------------------------------------------
% f0  - objective value at x0
% g0  - constraint values at x0  
% Initial function evaluation
% Objective and constraints for Rosen-Suzuki four-variable problem.
  [f0,g0] = Fun(x);
  f0last  = f0;
  g       = g0(:);

  ncs     = length(g);
  lenv    = ncs + lenvlb + lenvub;
  [mg,mj] = max([abs(g(1:nec)); g(nec+1:ncs)]);
  lb      = (ncs  + 1:ncs  + lenvlb)';
  ub      = (lenv - lenvub + 1:lenv)';

% ------------------------------------------------------
% Grd - (optional) string name of a function file which
% returns a vector of function gradients and a
% matrix of constraint gradients (i.e. [fp,gp]=grd(x)).
% grd = @(x) feval(Grd,xshape(x),varargin{:});

% Check gradients
  ACTIVE_CONSTRAINTS = 1:ncs;
% Objective and constraint gradients for Rosen-Suzuki four-variable problem.
  [fp,gp] = Grd(x);
  fp      = fp(:);
  nfcn    = 1;
  ngrd    = 1;

  ALL_CONSTRAINT_GRADIENTS = gp;
  ACTIVE_CONSTRAINTS = [];
  
% Check Hessian of Lagrangian: H
  H = eye(ndv);
  
% Check Lagrange multipliers: v
  v        = zeros(lenv,1);
  v(1:ncs) = guessLM(fp,gp,g,ncs,nec);
  
% Scale functions and gradients
  lscf = 0;
  lscg = 0;
  
  scf  = 1;
  scg  = 1;
  mscg = 1;

  [f,g,gv,Best] = scalefg( f0,  g, scf, scg, lscg,    x,  vlb, vub,    ilb,    iub, v);
  [fp,gp,gpv  ] = scalefgp(fp, gp, scf, scg, lscf, lscg, scdv,  x1, lenvlb, lenvub);
  
% --------------------------------------------------------------------
% Initialize variables
  nit = 0;
  mu = 1e-4; beta = 1e-1;
  r = 1e-2*ones(lenv,1);
  rub = 1e9;
  rstep = 10;
  s = [];
  rholb = 1;
  rhoub = 1e6;
  rhostep = 100;
  rho = 1;
  deltaub = 0.9;
  alpha = 0;
  min_alpha = sqrt(eps);
  dx = 0;
  ext_pen = 0;
  aug = 'f';
  aeps = 1.8*eps;
  pert = 0;
  nopt = 0;
  sqacc = sqrt(opts(3));
  fs = '%5.0f %12.5g %9.3g %4.0f %10.3g %4.0f  %9.3g %9.3g';
% ---------------------------------------------------------------------
% Display appropriate banner if opts(1)>0
 
  b5 = blanks(5);
  ban1s = ' Termination Criteria ';
  ban2s = ['f-CNT' b5  '    FUNC' b5 ' STEP  NAC' b5 'max{g}    j  ' b5];
  disp(' '); 
  disp([blanks(41) ban1s]);
  disp(sprintf('%44.3g  %14.3g %9.3g',opts(4),opts(3),opts(2)));
  disp([blanks(34) '-------------------------------------']);
  ban3s = ' KTO    max(S)';
  disp([ban2s ban3s]);
  
% --------------------------------------------------------------------
% ================== ####### Start Main Loop######### =================
% ================== #######                ######### =================
% Start Main Loop
  while nit <= opts(15)
        nit      = nit + 1;
        minalpha = min_alpha;
        status   = 0;
      % ------------------------------------------------------------------
      % Solve QP problem for search direction
        [s,u,statusqp] = qp(H,fp,gp',-g,vlb - x(ilb),vub - x(iub),s,nec,-1);
        delta    = 0;
        sHsfail  = 0;
        z0p1fail = 0;
        augfail  = 0;
        if aug == 'f'
           nAS = 0;
        end
        aug = 'f';
        SCV = sum(abs(g(1:nec))) + sum(max(0,g(nec + 1:ncs)));

      % Check status of QP problem
        statusok = strcmp(statusqp(1:2),'ok') || strcmp(statusqp(1:3),'max');
        violated = (SCV >= sqacc && opts(6) == -1 || mg > opts(4));
        if statusok
           if violated && ~UserHessian && s'*H*s < eps
              sHsfail = 1;
           else
              sigma = min(r,nit*sqrt(r));
              r = min(rub,2*ncs*(u - v).^2/((s'*H*s) + (1 - delta)));
              r = max(sigma,r);
           end
           [z0,z0p1] = merit(v,r,nec,f,gv,fp,gpv,u,s);
           while z0p1 > 0 && max(r) < rub
                 [z0,z0p1] = merit(v,r,nec,f,gv,fp,gpv,u,s);
                 if z0p1 > 0
                    r=r*rstep;
                 end
           end
           z0p1fail = z0p1 > 0; % && (fp+gpv*u)'*s>0;
      else
          if opts(1) && ~strcmp(statusqp(1:2),'in')
             disp(['QP problem is ' statusqp '.']);
          end
          if nit~=1
              if isempty(s)
                 rho = rholb;
              else
                 rho = (2*s'*H*s*(fp'*s)^2);
                 rho = max(rholb,rho);
              end
          end
          delta = 1;
      end
      slb = [-inf*ones(ndv,1);0]; if lenvlb, slb(ilb) = vlb - x(ilb); end
      sub = [ inf*ones(ndv,1);1]; if lenvub, sub(iub) = vub - x(iub); end
      
    % Modified QP problem if the previous problem is infeasible
      mod = 'f';
      rho = min(rho,rhoub);
      while aug == 'f' && (delta >= deltaub || z0p1fail || sHsfail)
          while delta >= deltaub && rho <= rhoub
              mod = 't'; sHsfail = 0;
              [sdelta,udelta,statusqp]=qp([H zeros(ndv,1);zeros(1,ndv) rho],...
                  [fp;0],[gp', -g],-g,slb,sub,[zeros(ndv,1);1],nec,-1);
              s = sdelta(1:ndv);
              if length(udelta) == 0
                  u = [];
              else
                  u = udelta(1:lenv);
              end
              delta = sdelta(ndv + 1);
              statusok = strcmp(statusqp(1:2),'ok');
              if statusok
                  if violated && s'*H*s<eps
                     sHsfail = 1; break
                  end
              else
                  status = ['Modified QP problem is ' statusqp '.'];
                  break
              end
              rho = rho*rhostep;
          end
 
        % Try augmented Lagrangian search direction if all else fails
          if aug == 'f' && (sHsfail || delta > deltaub || ~statusok)
              aug = 't'; nAS = nAS + 1; sHsfail = 0; delta = 0;
              [z0,z0p1,z0p2,z0p3] = merit(v,r,nec,f,gv,fp,gpv,u,s);
              [s,u1,statusqp] = qp(H,z0p2,[],[],slb(ilb),sub(iub),s,nec,-1);
              u = v + z0p3; u([lb ub]) = u1;
              if ~(strcmp(statusqp(1:2),'ok') || strcmp(statusqp(1:3),'max'))
                  status =['Augmented Lagrangian QP problem is ' statusqp '.'];
                  fail = 1; break
              elseif (SCV >= sqacc && opts(6) == -1 || mg>opts(4))
                  if s'*H*s < eps
                     status ='Underflow in s''*H*s and infeasible iterate x.';
                     fail = 1; break
                  end;
              elseif max(abs(s)) < eps
                  fail = 1; break
              end;
          end
          if aug == 'f' && mod == 't'
              sigma = min(r,nit*sqrt(r));
              r = min(rub,2*ncs*(u-v).^2/((s'*H*s) + (1 - delta)));
              r = max(sigma,r);
          end
          [z0,z0p1] = merit(v,r,nec,f,gv,fp,gpv,u,s);
          z0p1fail = z0p1 >= 0;
          while z0p1fail && max(r)<=rub
              r = r*rstep;
              [z0,z0p1] = merit(v,r,nec,f,gv,fp,gpv,u,s);
              z0p1fail = z0p1 >= 0;
          end
          if z0p1fail
              if mod == 't' && rho<rhoub
                 delta = 1; rho = rho*rhostep;
              else
                 statusok = 0;
              end
          end
      end
    % ------------------------------------------------------------------
    % Display results and check termination criteria
      if scdv, ms = max(abs(s.*x1)); else  ms = max(abs(s)); end
      AG = abs(fp'*s)/scf; j = find(u&isfinite(gv));
      KTO = AG + sum(abs(u(j).*gv(j)));
      NAC = length(find(gv >= 0 | u ~= 0|(gv < 0 & (1:length(gv))' <= nec)));
      if aug == 't'
         NLG = z0p2;
         if any(isfinite(vlb));NLG(ilb) = NLG(ilb) - u(lb);end
         if any(isfinite(vub));NLG(iub) = NLG(iub) - u(ub);end
      else
          NLG = fp + gpv*u;
      end

    % Add some trouble shooting info to display if opts(1)>1;
      if opts(1)>1
          if mod=='t', trouble=[trouble ' mS'];end %#ok<*AGROW>
          if aug=='t', trouble=[trouble ' aS'];end
          if ext_pen,  trouble=[trouble ' xp'];end
          if pert>0,   trouble=[trouble ' dH=' num2str(pert)];end
          if ischar(UpdHess), trouble=[trouble UpdHess];end; UpdHess=[];
      end
      if opts(1)>2,NLGs=num2str(max(abs(NLG)),4);DBDs=num2str(s'*H*s,4);end

    % Display iteration info
      if opts(1)
          if mj > lenv - lenvub, mj = mj - ncs - lenvlb; fs(38) = '+';
          elseif mj > ncs, mj = mj - ncs; fs(38) = '-';
          else  fs(38) = ' ';
          end
          if opts(1) > 3 && nit ~= 1
             disp(['ITERATION ' int2str(nit - 1)]); % -1 to match Sch.
             disp([ban2s ban3s]);
          end
          if opts(6)==(-1)
             disp([sprintf(fs,nfcn,f0,alpha,NAC,mg,mj,SCV,KTO),trouble]);
          elseif opts(6)==1
             disp([sprintf(fs,nfcn,f0,alpha,NAC,mg,mj,AG/2,ms/2),trouble]);
          elseif opts(6)==2
             disp([sprintf(fs,nfcn,f0,alpha,NAC,mg,mj,norm(NLG,inf),norm(dx,inf)),trouble]);
          else
             disp([sprintf(fs,nfcn,f0,alpha,NAC,mg,mj,KTO,ms),trouble]);
          end
          trouble = '';
      end
 
    % Check termination criteria
      if opts(6) == (-1)
         if KTO <= opts(3) && SCV <= sqacc; v = u; break; end;
      elseif opts(6) == 1
          if ms/2 < opts(2) && AG/2 < opts(3) && mg < opts(4); v = u; break; end
      elseif opts(6) == 2
          [z0,z0p1,z0p2] = merit(v,r,nec,f,gv,fp,gpv,u,s);
          Slowed     = abs(f - z0)      < opts(3) && nit > 1 && ...
                       abs(f0 - f0last) < opts(3) && max(abs(dx)) < opts(2);
          if (Slowed || norm(NLG,inf) < opts(3))&& mg < opts(4); v = u; break; end
      else
          if ms < opts(2) && KTO < opts(3) && mg < opts(4); v = u; break; end
      end
      if max(abs(NLG)) < sqacc && s'*H*s < opts(3)
         nopt = nopt + 1;
         if nopt == 3
            status = 'User termination criteria not met, but merit gradient is zero for 3 iterations.';
            v = u; break
         end
      else
         nopt = 0;
      end
      if ~isempty(lenvlb), s(ilb) = max(s(ilb),slb(ilb)); end
      if ~isempty(lenvub), s(iub) = min(s(iub),sub(iub)); end
      if max(abs(s))<eps
         status = 'Adequate search direction could not be found.'; break
      elseif ~all(isfinite(u)) || ~all(isfinite(v))
         status = ('Lagrange Multipliers not finite'); v = vold; break
      elseif pert > 1
         status = 'Hessian no longer positive definite'; break
      else
         pert = 0;
      end
      if any(u(nec + 1:ncs)<0)
         if aug ~= 't', disp('sqp--Negative Lagrange Multipliers corrected'), end
         neg = u(nec + 1:ncs) < 0;
         u(neg) = abs(u(neg)).*(g(neg) >= 0 || gp(:,neg)'*s > 0);
      end
     
    % ------------------------------------------------------------------
    % Perform line search using Schittkowski's L2 merit function

    % Evaluate the merit function at alpha = 1
      xold = x; vold = v; v = u;leastmg =mg; mg0 = mg; g0 = g; ext_pen = 0;best = 0; nlin = 0;alpha = 1;
      if ~(augfail || z0p1fail)
         x = xold + alpha*s;
         [f0,g] = Fun(x); nfcn = nfcn + 1;
         [f,g,gv,Best] = scalefg(f0, g, scf, scg, lscg, x, vlb, vub, ilb, iub, u, opts(4), Best );
        
       % Establish the termination criteria
         z=merit(v,r,nec,f,gv);
         minalpha = min(opts(2)/max(abs(s)), minalpha);
         if length(z0p1) == 0
             z0p1 = 0;
         end
         while z > z0 + mu*alpha*z0p1 && nlin < nlinmax && alpha > minalpha
               nlin = nlin + 1;
            
           % Use 2pt quadradic approx to minimize the merit function
             a2 = ((z - z0)/alpha - z0p1)/alpha;
             alpha = max([beta*alpha,-z0p1/2/a2,minalpha]);
             x = xold + alpha*s; v = vold + alpha*(u - vold);
             [f0,g] = Fun(x); nfcn = nfcn + 1;
             [f,g,gv,Best]=scalefg( f0, g, scf, scg, lscg, x, vlb, vub, ilb, iub, v, opts(4), Best );
             mg = max([abs(g(1:nec)); g(nec + 1:ncs); gv(ncs + 1:lenv)]);
             z = merit(v,r,nec,f,gv);
          end
          z0p1fail = z > z0 + mu*alpha*z0p1; best = alpha;
      end
    %
      if (z0p1fail && mg >= max(mg0,opts(4))) && opts(6)==0
          ext_pen = 1;
          vlm = guessLM(fp,gp,g,ncs,nec);
          minalpha = min( 1, max( opts(2)/max(abs(s)), alpha ) );
        % s = qp([],gp*vlm,[],[],slb(1:lenvlb),sub(1:lenvub),s,nec,-1);
          [s,u1] = qp(eye(ndv)/minalpha,gp*vlm,[],[],slb(ilb),sub(iub),s,nec,-1);
          [z0,z0p1] = merit(vlm,[],nec,[],g0,[],gp,[],s); % exterior penalty
          if max(abs(s)) > eps && z0 > eps
             u = [vlm; u1];
          else
             status = ('No feasible direction to reduce L1 penalty');
             break
          end
          alpha = 1;
          x = xold + alpha*s;
          [f0,g] = Fun(x); nfcn = nfcn + 1;
          [f,g,gv,Best] = scalefg( f0, g, scf, scg, lscg, x, vlb, vub, ilb, iub, u, opts(4), Best );
          mg = max([abs(g(1:nec)); g(nec + 1:ncs); gv(ncs + 1:lenv)]);
          if mg < leastmg && mg > (-eps)
             leastmg = mg; best = alpha; bestf = f; bestgv = gv; bestx = x;
          end
          z = merit(vlm,[],nec,[],g);
          z0p1fail = mg > leastmg || mg < (-opts(4)) || z > z0 + mu*alpha*z0p1;
          nlinmax2 = nlin + nlinmax;
          if max(abs(s))>opts(2)/2
             minalpha = min( opts(2)/max(abs(s)), min_alpha );
          else
             alpha = 0;
          end
          while z0p1fail && nlin < nlinmax2 && alpha > minalpha
              nlin = nlin+1;
              a2 =((z - z0)/alpha - z0p1)/(alpha);
              alpha = max([beta*alpha,-z0p1/2/a2,minalpha]);
              x = xold + alpha*s; v = vold + alpha*(u - vold);
              [f0,g] = Fun(x); nfcn = nfcn + 1;
              [f,g,gv,Best] = scalefg( f0, g, scf, scg, lscg, x, vlb, vub, ilb, iub, v, opts(4), Best );
              mg = max([abs(g(1:nec)); g(nec + 1:ncs); gv(ncs + 1:lenv)]);
              z = merit(vlm,[],nec,[],g);
              z0p1fail = mg > leastmg || mg < (-opts(4)) || z > z0 + mu*alpha*z0p1;
              if mg < leastmg && mg>(-opts(4))
                 leastmg = mg; best = alpha; bestf = f; bestgv = gv; bestx = x;
              end
          end
      end
      if nAS >= 3 && leastmg > Best.mg
         status='Augmented Search direction failed after 3 tries.';
         break
      elseif z0p1fail
         if leastmg < mg0
            alpha = best; f = bestf; gv = bestgv; g = bestgv(1:ncs); x = bestx; s = x - xold;
            v = vold + alpha*(u - vold);
            if opts(1) > 2
               disp(['sqp - Line search: mg0 = ' num2str(mg0) ' leastmg =' num2str(leastmg)])
            end
         elseif alpha == 0 || best == 0
            status = 'No significant improvement found in line search.'; break
         end
      end
      [mg,mj] = max([abs(g(1:nec)); g(nec + 1:ncs); gv(ncs + 1:lenv)]);
      if nfcn > opts(14)
          status = 'Maximum # function evaluations exceeded. Increase opts(14).'; break
      elseif nit > opts(15)
          status = 'Maximum iterations exceeded. Increase opts(15).'; break
      end
     
    % ------------------------------------------------------------------
    % Evaluate gradients using active set strategy
      ACTIVE_CONSTRAINTS = union(find(u(1:ncs) | g > opts(4)),ACTIVE_CONSTRAINTS);
      
    % [fpnew,gpnew] = eval(grdstr);
    % Objective and constraint gradients for Rosen-Suzuki four-variable problem.
      [fpnew,gpnew] = Grd(x);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      fpnew = fpnew(:); ngrd = ngrd + 1;
% % %       if fd_gradients
% % %          nfcn = nfcn + ndv;
% % %       end
      nac = length(ACTIVE_CONSTRAINTS);
      ng = size(gpnew,2);
      if ng < ncs
         if ng == nac
            ALL_CONSTRAINT_GRADIENTS(:,ACTIVE_CONSTRAINTS) = gpnew;
            gpnew = ALL_CONSTRAINT_GRADIENTS;
         else
            error(['User supplied number of gradients = ' num2str(ng) ' ~= active # = ' num2str(nac)])
         end
      else
         if nac == ncs
            ALL_CONSTRAINT_GRADIENTS = gpnew;
         else
            ALL_CONSTRAINT_GRADIENTS = [];
         end
      end
      if lscg
         insc = find(v(1:ncs) == 0 & g < eps); mscg = scg;
         if insc;mscg(insc) = ones(size(insc));end
      end
      [fpnew,gpnew,gpv] = scalefgp( fpnew, gpnew, scf, mscg, lscf, lscg, scdv, x1, lenvlb, lenvub );
      if aug == 't'
         qq = z0p2;
         if ~isempty(vlb); slb = zeros(ndv,1);slb(ilb) = u(lb);qq = qq + slb; end
         if ~isempty(vub); sub = zeros(ndv,1);sub(iub) = u(ub);qq = qq + sub;end
      elseif isempty(ACTIVE_CONSTRAINTS)
         qq = fpnew - fp;
      else
         qq = (fpnew - fp) + (gpnew(:,ACTIVE_CONSTRAINTS) - gp(:,ACTIVE_CONSTRAINTS))*u(ACTIVE_CONSTRAINTS);
      end
      dx = alpha*s;
    % ------------------------------------------------------------------
    
    % Update the Hessian using Powell's modified BFGS method
      if UserHessian
         H = feval(Opts.HessFun,xshape(x),v,varargin{:});
         if scdv, H=diag(x1)*H*diag(x1); end;
      else
         Hdx = H*dx;
         Y = dx'*Hdx;
         if dx'*qq >= .2*Y
            q = qq;
         else
            theta = .8*Y/(Y - dx'*qq);
            q = theta*qq + (1 - theta)*Hdx;
         end
         if q'*dx<eps % Try nlconst perturbation
            factor = gpnew*g - gp*g0;
            [q,UpdHess] = nlconst_HessUpd( qq, dx, H, factor, alpha );
         end
         H = H + (q*q')/(q'*dx)-(Hdx*Hdx')/Y;
         Hnonsym = norm(H-H',inf);
         if Hnonsym > eps
            H = (H + H')/2;
            if Hnonsym/norm(H,inf) > 1e-4, disp('sqp- Warning: H was not symmetric'), end
         end
         if max(Y,q'*dx) < eps %&& rcond(H)<eps
            try
               chol(H);
            catch
              % Increase the diagonal elements of H if H is ill-conditioned
                dE = abs(eig(H,'nobalance'));
                pert =(min(dE) + aeps*max(dE))/(1 - aeps);
                H = H + pert*eye(ndv);
            end
         end
      end
      fp = fpnew; gp = gpnew;
    % ------------------------------------------------------------------
    % Display additional trouble shooting information if opts(1)>2
      if opts(1) > 2
         DLPs = num2str(z0p1,4);MFs = num2str(z,4);
          disp(['NLG = ' NLGs blanks(12 - length(NLGs)) 'DBD = ' DBDs,...
               blanks(12 - length(DBDs)) 'DLP = ' DLPs blanks(12 - length(DLPs)),...
              'MERIT FCN = ' MFs]);disp(' ');
      end
      if opts(1) > 3
         vold = vold/scf; if lscg,vold(1:ncs) = vold(1:ncs).*scg;end;
         disp('VARIABLE:  X = ');disp(xold(:)');
         disp('MULTIPLIERS:  U = ');disp(vold(:)');
         disp('PENALTY PARAMETER:  R = '); disp(r(:)');
         disp(' ');disp(' ');
      end
  end
% ---------------------------------------------------------------------
% Display final results and return information in opts
  if length(v) ~= lenv
     v = vold;
  end
  if opts(1) > 2 && ~ischar(status) && nargout < 3
     disp(' Active Constraints ')
     disp(find(v(1:ncs))')
     if any(v(lb)), disp('Active Lower Bounds'), disp(find(v(lb))'), end;
     if any(v(ub)), disp('Active Upper Bounds'), disp(find(v(ub))'), end;
     if any(v)
        disp(' Lagrange Multipliers ')
        disp(sprintf('%12.4g   %12.4g   %12.4g   %12.4g   %12.4g\n',v(v~=0)))
     end
  end
  if ischar(status) % (Not implemented in scalefg for equality constraints)
     if ((mg > opts(4) && mg>Best.mg) || (mg <= opts(4) && f > Best.Obj)) && nec == 0 && Best.nit > 1
        x = Best.X;
        f = Best.Obj;
        v = Best.LM;
        if opts(1), disp(sprintf(fs,nfcn,f,0,0,Best.mg,Best.mj)); end
        if nargout < 5, disp('Optimum not found in sqp. Returning most feasible solution.'), end
      end
      if nargout < 5 && nec
         error(status)
      elseif opts(1)
         disp(['sqp: ',status])
         disp(' ')
      end
  elseif opts(1)
      disp('Optimization Terminated Successfully from sqp')
      disp(' ')
  end
  if scdv
     x=reshape(x1.*x,size(x0,1),size(x0,2));
     if nargout>3, H=diag(1./x1)*H*diag(1./x1); end;
  elseif size(x)~=size(x0)
     x=reshape(x,size(x0,1),size(x0,2));
  end;
  if nargout > 1
     opts(8) = f;opts(10) = nfcn;opts(11) = ngrd;
     opts(12) = opts(10);opts(14) = nit - 1;
     v = v/scf; if lscg,v(1:ncs) = v(1:ncs).*scg; end; % Scale Lagrange Multipliers
     if isstruct(Opts) && ~isfield(Opts,'foptions')
        [opts,v] = sqpstructout(opts,v(1:ncs),v(lb),v(ub));
     end
  end
  end
% -------------------------------------------------------------------------
% ================== ####### End of sqp main routine ######### ============
% =========================================================================
% Sub-function to evaluate the descent merit function
  function [psi,psip1,psip2,psip3] = merit(v,r,nec,f,g,fp,gp,u,s)
% MERIT     Evaluates the merit function associated with the line
%           search in sqp.m.
% usage:    [psi,psip1,psip2,psip3] = merit(v,r,nec,f,g,fp,gp,u,s)
%
% inputs:   v     - Estimates of the optimal Lagrange multipliers
%           r     - scalar penalty parameter
%           nec   - number of equality constraints
%           f     - function value
%           g     - constraint values
%           fp    - (required for psip1-3) function gradient
%           gp    - (required for psip1-3) constraint gradients
%           u     - (required for psip1-3) Lagrange multipliers
%                   for QP search direction problem
%           s     - (required for psip1-3) search direction
%
% outputs:  psi   - value of the merit function at alpha
%           psip1 - derivative of the merit function wrt alpha
%           psip2 - derivative of the merit function wrt x
%           psip3 - derivative of the merit function wrt v
%  
% Created by:    Capt Mark Spillman
  if nargin < 9 && nargout > 1
     error('merit - 9 input arguments must be provided to compute psip1-3.')
  end
  if nargin < 5; error('merit - 5 input arguments must be provided.'); end

% L1 Exterior penalty for infeasible designs
  if isempty(r)
     ncs = length(v);
     v = v.*(g(1:ncs) > 0 & v > 0 | (1:ncs)' <= nec); % positive multipliers for ineq.
     psi = abs(v)'*[abs(g(1:nec)); max(0,g(nec+1:ncs))];
     if nargout > 1
        psip1 = s'*gp*v;
     end
     return
  end
 
% Switch signs on g and gp to match Schittkowski's conventions
  g = -g;
  if nargin > 5
     gp = -gp;
  end

% Determine the active(a) and inactive(i) constraints
  ncs = size(v,1);
  a = find(g(nec + 1:ncs) <= v(nec+1:ncs)./r(nec + 1:ncs));
  a = [1:nec a' + nec];
  i = find(g(nec + 1:ncs) >  v(nec+1:ncs)./r(nec + 1:ncs));
  i = i + nec;

% Evaluate the merit function
  if isempty(a) && isempty(i)
     psi = f;
  elseif isempty(a)
     psi = f - sum(.5*(v.^2)./r);
  elseif isempty(i)
     psi = f - (v'*g - .5*r'*g.^2);
  else
     psi = f - sum(.5*(v(i).^2)./r(i)) - (v(a)'*g(a) - .5*r(a)'*g(a).^2);
  end

% Evaluate psip1, psip2 and psip3
  if nargout > 1
     psip3 = zeros(ncs,1);
     if isempty(a) && isempty(i)
         psip2 = fp;
         psip1 = fp'*s;
     elseif isempty(a)
         psip3 = -(v./r);
         psip2 = fp;
         psip1 = psip2'*s + psip3'*(u - v);
     elseif isempty(i)
         psip3 = -g;
         psip2 = fp - gp*(v - r.*g);
         psip1 = psip2'*s + psip3'*(u - v);
     else
         psip3(i) = -v(i)./r(i);psip3(a) = -g(a);
         psip2    = fp - gp(:,a)*(v(a) - r(a).*g(a));
         psip1    = psip2'*s - (v(i)./r(i))'*(u(i) - v(i)) - g(a)'*(u(a) - v(a));
     end
  end
  end
% ======================================================================
% ======================================================================
% Sub-function to scale objective, f0, and constraints, g0
  function [f,g,gv,Best] = scalefg( f0, g0, scf, scg, lscg, x, vlb, vub, ilb, iub, v, tolcon, Best )
% Modified:  5/12/06 - allow empty g
%           12/11/07 - Track best design
  if isempty(g0), g0 = -inf; end
  g = g0(:);
  [mg,mj] = max(g);
  if nargin < 13 || Best.mg > tolcon && mg < Best.mg || mg <= tolcon && f0 < Best.Obj
     Best.Obj = f0;
     Best.LM  = v;
     Best.X   = x;
     Best.mg  = mg;
     Best.mj  = mj;
     if nargin < 13
        Best.nit = 1;
     else
        Best.nit = 2;
     end
  end
  f = scf*f0;
  if lscg
     gv = scg.*g;
  else
      gv = g;
  end
  if ~isempty(vlb)
      gv = [gv; vlb - x(ilb)];
  end
  if ~isempty(vub)
      gv = [gv; x(iub) - vub];
  end
  end
% ======================================================================
% ======================================================================
% Sub-function to scale objective gradient, fp, and constraint gradients, gp
  function [fp,gp,gpv] = scalefgp(fp, gp, scf, scg, lscf, lscg, scdv, x1, lenvlb, lenvub)
  ndv = length(fp);
  if isempty(gp) || (length(gp) == 1 && gp == 0)
     gp = zeros(ndv,1);
  end % unconstrained problem
  if lscf
     fp = scf*fp;
  end
  if lscg
     gp = (ones(ndv,1)*scg').* gp;
  end
  if scdv
     fp = x1.*fp;
     gp = diag(x1)*gp;
  end
  if lenvlb
     gpv = [gp  -eye(ndv,lenvlb)];
  else
     gpv = gp;
  end
  if lenvub
     gpv = [gpv  eye(ndv,lenvub)];
  end
  end
% ======================================================================
% ======================================================================
% Sub-function to guess the Lagrange Multipliers
  function v = guessLM(fp,gp,g,ncs,nec)
% Minimum of a constrained nonlinear multivariable function,
%    min          f (x )    
%    such that    g (x ) <= 0
%                 x E R^n
% fp  : vector of function gradients
% gp  : matrix of constraint gradients
% g   : constraint values
% ncs : length of g
% nec : number of equality constraints
  if isempty(gp) || (length(gp) == 1 && gp == 0)
      v = 0;
      return
  end % unconstrained problem
  den = gp'*fp;
  if any(den == 0)
      vlm = ones(ncs,1);
      vlm(den ~= 0) = -fp'*fp./den(den ~= 0);
      vlm = vlm.*exp(g - max(g) );
  else
      vlm = -fp'*fp./den.*exp(g - max(g) );
  end
% ==== Ver aqui ======
  v = vlm.*(g > 0 & vlm > 0 | (1:ncs)' <= nec); % positive multipliers for ineq.
  end
% ======================================================================
% ======================================================================
% Sub-function for Hessian Update with nonlinear constraints
  function [YL,how] = nlconst_HessUpd( YL, sdiff, HESS, FACTOR, steplength )
% Make sure Hessian is positive definite in update.
  if YL'*sdiff < steplength^2*1e-3
     while YL'*sdiff < -1e-5
        [YMAX,YIND] = min(YL.*sdiff); %#ok<ASGLU>
        YL(YIND) = YL(YIND)/2;
     end
     if YL'*sdiff < (eps*norm(HESS,'fro'))
        how = ' Hessian modified twice';
        FACTOR = FACTOR.*(sdiff.*FACTOR>0).*(YL.*sdiff<=eps);
        WT = 1e-2;
        if max(abs(FACTOR)) == 0; FACTOR = 1e-5*sign(sdiff); end
        while YL'*sdiff < (eps*norm(HESS,'fro')) && WT < 1/eps
            YL = YL + WT*FACTOR;
            WT = WT*2;
        end
     else
       how =' Hessian modified ';
     end
   else
      how=[];
   end
   end
% ---------------------------END OF FILE-------------------------------
% ======================================================================
% ======================================================================