module StatisticsHelper
  def jitBarChart(title_id)
    stock = Stock.find_all_by_title_id(title_id, :order => "branch_id")
  
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
    strata_child = {"id"=>"801", "name"=>"Strata", "data"=>{"band"=>"Strata", "relation"=>"main", "subdomain"=>"strata"},"children"=>[]}
    strata_children<<  strata_child
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
      "id"=> "1_1",
      "name" => "Select City",
      "children"=>strata_children,
      "data"=>{ "subdomain"=>"city"}
    }
  end
  
  def temp
  json = {  
    "id"=> "347_0",  
    "name"=> "Nine Inch Nails",  
    "children"=> [{  
        "id"=> "126510_1",  
        "name"=> "Jerome Dillon",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "52163_2",  
            "name"=> "Howlin' Maggie",  
            "data"=> {  
                "band"=> "Jerome Dillon",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "324134_3",  
            "name"=> "nearLY",  
            "data"=> {  
                "band"=> "Jerome Dillon",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }]  
    }, {  
        "id"=> "173871_4",  
        "name"=> "Charlie Clouser",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> []  
    }, {  
        "id"=> "235952_5",  
        "name"=> "James Woolley",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> []  
    }, {  
        "id"=> "235951_6",  
        "name"=> "Jeff Ward",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "2382_7",  
            "name"=> "Ministry",  
            "data"=> {  
                "band"=> "Jeff Ward",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "2415_8",  
            "name"=> "Revolting Cocks",  
            "data"=> {  
                "band"=> "Jeff Ward",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "3963_9",  
            "name"=> "Pigface",  
            "data"=> {  
                "band"=> "Jeff Ward",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "7848_10",  
            "name"=> "Lard",  
            "data"=> {  
                "band"=> "Jeff Ward",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }]  
    }, {  
        "id"=> "235950_11",  
        "name"=> "Richard Patrick",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "1007_12",  
            "name"=> "Filter",  
            "data"=> {  
                "band"=> "Richard Patrick",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "327924_13",  
            "name"=> "Army of Anyone",  
            "data"=> {  
                "band"=> "Richard Patrick",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }]  
    }, {  
        "id"=> "2396_14",  
        "name"=> "Trent Reznor",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "3963_15",  
            "name"=> "Pigface",  
            "data"=> {  
                "band"=> "Trent Reznor",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "32247_16",  
            "name"=> "1000 Homo DJs",  
            "data"=> {  
                "band"=> "Trent Reznor",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "83761_17",  
            "name"=> "Option 30",  
            "data"=> {  
                "band"=> "Trent Reznor",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "133257_18",  
            "name"=> "Exotic Birds",  
            "data"=> {  
                "band"=> "Trent Reznor",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }]  
    }, {  
        "id"=> "36352_19",  
        "name"=> "Chris Vrenna",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "1013_20",  
            "name"=> "Stabbing Westward",  
            "data"=> {  
                "band"=> "Chris Vrenna",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "3963_21",  
            "name"=> "Pigface",  
            "data"=> {  
                "band"=> "Chris Vrenna",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "5752_22",  
            "name"=> "Jack Off Jill",  
            "data"=> {  
                "band"=> "Chris Vrenna",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "33602_23",  
            "name"=> "Die Warzau",  
            "data"=> {  
                "band"=> "Chris Vrenna",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "40485_24",  
            "name"=> "tweaker",  
            "data"=> {  
                "band"=> "Chris Vrenna",  
                "relation"=> "is person"  
            },  
            "children"=> []  
        }, {  
            "id"=> "133257_25",  
            "name"=> "Exotic Birds",  
            "data"=> {  
                "band"=> "Chris Vrenna",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }]  
    }, {  
        "id"=> "236021_26",  
        "name"=> "Aaron North",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> []  
    }, {  
        "id"=> "236024_27",  
        "name"=> "Jeordie White",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "909_28",  
            "name"=> "A Perfect Circle",  
            "data"=> {  
                "band"=> "Jeordie White",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "237377_29",  
            "name"=> "Twiggy Ramirez",  
            "data"=> {  
                "band"=> "Jeordie White",  
                "relation"=> "is person"  
            },  
            "children"=> []  
        }]  
    }, {  
        "id"=> "235953_30",  
        "name"=> "Robin Finck",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "1440_31",  
            "name"=> "Guns N' Roses",  
            "data"=> {  
                "band"=> "Robin Finck",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }]  
    }, {  
        "id"=> "235955_32",  
        "name"=> "Danny Lohner",  
        "data"=> {  
            "band"=> "Nine Inch Nails",  
            "relation"=> "member of band"  
        },  
        "children"=> [{  
            "id"=> "909_33",  
            "name"=> "A Perfect Circle",  
            "data"=> {  
                "band"=> "Danny Lohner",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "1695_34",  
            "name"=> "Killing Joke",  
            "data"=> {  
                "band"=> "Danny Lohner",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "1938_35",  
            "name"=> "Methods of Mayhem",  
            "data"=> {  
                "band"=> "Danny Lohner",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "5138_36",  
            "name"=> "Skrew",  
            "data"=> {  
                "band"=> "Danny Lohner",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "53549_37",  
            "name"=> "Angkor Wat",  
            "data"=> {  
                "band"=> "Danny Lohner",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "113510_38",  
            "name"=> "Puscifer",  
            "data"=> {  
                "band"=> "Danny Lohner",  
                "relation"=> "member of band"  
            },  
            "children"=> []  
        }, {  
            "id"=> "113512_39",  
            "name"=> "Renhold\u00ebr",  
            "data"=> {  
                "band"=> "Danny Lohner",  
                "relation"=> "is person"  
            },  
            "children"=> []  
        }]  
    }],  
    "data"=> []  
    } 
    json
  end
end
