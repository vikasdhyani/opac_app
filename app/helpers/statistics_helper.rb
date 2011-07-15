module StatisticsHelper
  def jitBarChart(title_id)
    stock = Stock.find_all_by_title_id(title_id, :conditions=>['branch_id != 951'], :order => "branch_id")
  
    stockArray = []
  
    stock.each do |storeStock|
      stockArray << storeStock.to_jit
    end
  
    {
      'label' => ['in circulation', 'in store', 'unavailable', 'assigned', 'other branch in store'],
      'values' => stockArray
    }
  end
  
  def IBTRstatChartData(ibtr_stats)
    #params = {=>Created => 'All'}
    #ibtr_stats = Ibtr.get_ibtr_stats(params)
  
    statArray = []
  
    ibtr_stats.each do |ibtrStat|
      statArray << Ibtr.to_jit(ibtrStat)
    end
    {
      'label' => ['New', 'Assigned','Out of Stock', 'POPlaced', 'Fulfilled', 'Dispatched','Received','Delivered','Timedout','Declined','Cancelled','Duplicate'],
      'values' => statArray
    }
  end

  def IBTRrespChartData(ibtr_stats)
    #params = {=>Created => 'All'}
    #ibtr_stats = Ibtr.get_ibtr_stats(params)
  
    statArray = []
  
    ibtr_stats.each do |ibtrStat|
      statArray << Ibtr.resp_to_jit(ibtrStat)
    end
  
    {
      'label' => ['Assigned','POPlaced', 'Fulfilled', 'Declined', 'Dispatched'],
      'values' => statArray
    }
  end

  def jitTreeChart 
    strata_children = []
    cities = City.find_all_by_jb_present('Y')
    cities.each do |city|
      city_children = []  
      branches = Branch.find_all_by_city_id_and_category(city.id, 'P')
      branches.each do |branch|
        branch_children =[]
        sats = Branch.find_all_by_parent_id_and_category(branch.id, 'S')
        #sats << branch
        sats.each do |sat|
          branch_child ={"id" => sat.id, "name"=>sat.name, "data"=>{"band"=>branch.name, "relation"=>"satellite", "subdomain"=>branch.subdomain}, "children"=>[]}
          branch_children << branch_child 
        end
        city_child = {"id"=>"fran_"+branch.id.to_s, "name"=>branch.name, "data"=>{"band"=>city.name, "relation"=>"branch", "subdomain"=>branch.subdomain}, "children"=>branch_children}
        city_children << city_child
      end
      strata_child = {"id"=>"801_"+city.id.to_s, "name"=>city.name, "data"=>{"band"=>"JustbooksClc", "relation"=>"city","subdomain"=>"city"},"children"=>city_children}
      strata_children << strata_child
    end
    strata_child = {"id"=>"801", "name"=>"Strata Staff", "data"=>{"band"=>"JustbooksClc", "relation"=>"city","subdomain"=>"strata"},"children"=>[]}
    strata_children << strata_child
    json = {
      "id"=> "801_jb",
      "name" => "JustbooksClc",
      "children"=>strata_children,
      "data"=>{ "subdomain"=>"city"}
    }
  end
  
  def jitTreeChart_old()
    
    strata_children = []
    cities = City.find_all_by_jb_present('Y')
    cities.each do |city|
      city_children = []  
      branches = Branch.find_all_by_city_id_and_category(city.id, 'P')
      branches.each do |branch|
        branch_children =[]
        sats = Branch.find_all_by_parent_id_and_category(branch.id, 'S')
        sats.each do |sat|
          branch_child ={"id" => sat.id, "name"=>sat.name, "data"=>{"band"=>branch.name, "relation"=>"satellite", "subdomain"=>branch.subdomain}, "children"=>[]}
          branch_children << branch_child 
        end
        city_child = {"id"=>branch.id, "name"=>branch.name, "data"=>{"band"=>city.name, "relation"=>"branch", "subdomain"=>branch.subdomain}, "children"=>branch_children}
        city_children << city_child
      end
      strata_child = {"id"=>"801_"+city.id.to_s, "name"=>city.name, "data"=>{"band"=>"Strata", "relation"=>"city","subdomain"=>"city"},"children"=>city_children}
      strata_children << strata_child
    end
    json = {
      "id"=> "801",
      "name" => "Strata",
      "children"=>strata_children,
      "data"=>{ "subdomain"=>"strata"}
    }
  end
end
