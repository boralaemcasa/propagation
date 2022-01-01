classdef GlobalClass
   properties
      N
      Mx
      My
      K
      F
      Layers
      Lower
      Upper
	  Gen
      MaxGen
      Ref
   end
   methods
      function pop = Initialization(obj)
          pop = feval(obj.F + "init", obj.N, obj.Mx);
      end
      function Offspring = Variation(obj, Population, MatingPool)
          Offspring = CVEA_IEAreal(obj, Population, MatingPool);
      end
      function [a, b, c, d] = ParameterSet(obj, a, b, c, d)
      end
   end
end