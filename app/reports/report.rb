class Report 
    extend Garb::Model   
end

# Override garb module for report parameter class to reset metrics & dimensions
module Garb
  class ReportParameter
    def reset elements=[]
      @elements = elements
    end
  end
end