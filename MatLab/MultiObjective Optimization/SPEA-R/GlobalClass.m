classdef GlobalClass
   properties
      N
      M
      K
      Layers
      Lower
      Upper
	  Epoca
   end
   methods
      function pop = Initialization(obj)
          % como vai convergir para S^M, que tal o plano sum(x) = constante?
          pop = rand(obj.N, obj.M);
          pop(:, obj.M) = 3 - sum(pop(:,1:obj.M-1),2);
      end
      function flagContinue = NotTermination(obj, Population)
          flagContinue = (obj.Epoca < 10);
      end
      function Offspring = Variation(obj, Population, MatingPool)
          Offspring = CVEA_IEAreal(obj, Population, MatingPool);
      end
      function [a, b, c, d] = ParameterSet(obj, a, b, c, d)
      end
   end
end