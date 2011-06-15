module IbAssignmentsHelper

def get_count(criteria , title_id, branchVal)
  case criteria
    when 'unpicked' then get_unpicked_count(title_id, branchVal)
    when 'picked'  then get_picked_count(title_id, branchVal)
    when 'all'  then get_all_count(title_id, branchVal)    
  end
end

def get_picked_count(title_id, branchVal)

  IbtHiddenReq.count(:all, :conditions => ['respondent_id = ? AND title_id =? ',  branchVal, title_id])

end

def get_unpicked_count(title_id, branchVal)

  get_all_count(title_id, branchVal) - get_picked_count(title_id, branchVal)

end

def get_all_count(title_id, branchVal)

  Ibtr.count(:all, :conditions => ['state=? AND respondent_id = ? AND title_id =? ', 'Assigned',  branchVal, title_id])

end
end
