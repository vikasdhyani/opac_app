class IbAssignment < ActiveRecord::Base

  belongs_to :title


def self.allRacks(params)
	
	picked_title_ids = [0]
  unpicked_title_ids =[0]
	title_ids = IbtHiddenReq.find(:all, :select => 'distinct title_id', :conditions => ['respondent_id = ? ',  params[:branchVal]])
	title_ids.each do |t|
		picked_title_ids << t.title_id
    picked_count = IbtHiddenReq.find(:all, :conditions => ['title_id = ? AND respondent_id = ?', t.title_id, params[:branchVal] ]).size
    assigned_count = Ibtr.find(:all, :conditions => ['state = ? AND title_id = ? AND respondent_id = ?', 'Assigned', t.title_id, params[:branchVal] ]).size
    if assigned_count <= picked_count
      unpicked_title_ids << t.title_id
    end
	end
	
	if params[:criteria] == 'unpicked'
		ib_assignemnts = IbAssignment.find(:all, :select => 'distinct category, rack ', :conditions => ['book_branch_id = ? AND title_id NOT IN ( ? )', params[:branchVal], unpicked_title_ids],:order => 'category, substr(rack,1)').paginate(:page => params[:page],:per_page => 5)
	elsif params[:criteria] == 'picked'
		IbAssignment.find(:all, :select => 'distinct category, rack ', :conditions => ['book_branch_id = ? AND title_id IN (? ) ', params[:branchVal], picked_title_ids],:order => 'category, substr(rack,1)').paginate(:page => params[:page],:per_page => 5)
	else
		IbAssignment.find(:all, :select => 'distinct category, rack ', :conditions => ['book_branch_id = ? ', params[:branchVal]],:order => 'category, substr(rack,1)').paginate(:page => params[:page],:per_page => (params[:prn].eql?('prn') ? 5000 : 5) )
	end
	
end

def self.allShelves(branchVal, rack, category , criteria)
	
	picked_title_ids = [0]
  unpicked_title_ids =[0]
	title_ids = IbtHiddenReq.find(:all, :select => 'distinct title_id', :conditions => ['respondent_id = ? ',  branchVal])
	title_ids.each do |t|
		picked_title_ids << t.title_id
    picked_count = IbtHiddenReq.find(:all, :conditions => ['title_id = ? AND respondent_id = ?', t.title_id, branchVal ]).size
    assigned_count = Ibtr.find(:all, :conditions => ['state = ? AND title_id = ? AND respondent_id = ?', 'Assigned', t.title_id, branchVal ]).size
    if assigned_count <= picked_count
      unpicked_title_ids << t.title_id
    end
	end
	if criteria == 'unpicked'
		IbAssignment.find(:all, :select => 'distinct rack, category, shelf ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND title_id NOT IN (?) ', 
				branchVal, 
				rack,
				category,
				unpicked_title_ids
				], :order => 'shelf')
	elsif criteria == 'picked'
		IbAssignment.find(:all, :select => 'distinct rack, category, shelf ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND title_id IN (?) ', 
				branchVal, 
				rack,
				category,
				picked_title_ids
				], :order => 'shelf')
	else
		IbAssignment.find(:all, :select => 'distinct rack, category, shelf ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ?', 
				branchVal, 
				rack,
				category
				])
	end
end

def self.allTitles(branchVal, rack, category ,shelf , criteria)

	picked_title_ids = [0]
	unpicked_title_ids =[0]
	title_ids = IbtHiddenReq.find(:all, :select => 'distinct title_id', :conditions => ['respondent_id = ? ',  branchVal])
	title_ids.each do |t|
		picked_title_ids << t.title_id
    picked_count = IbtHiddenReq.find(:all, :conditions => ['title_id = ? AND respondent_id = ?', t.title_id, branchVal ]).size
    assigned_count = Ibtr.find(:all, :conditions => ['state = ? AND title_id = ? AND respondent_id = ?', 'Assigned', t.title_id, branchVal ]).size
    if assigned_count <= picked_count
      unpicked_title_ids << t.title_id
    end
	end

	if criteria == 'unpicked'
		assigned_titles = IbAssignment.find(:all, :select => 'distinct title_id, rack, category, shelf, \'u\' as picked ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND shelf =?  AND title_id NOT IN (?) ', 
				branchVal, 
				rack,
				category,
				shelf,
				unpicked_title_ids
				])
	
	elsif criteria == 'picked'
		assigned_titles = IbAssignment.find(:all, :select => 'distinct title_id, rack, category, shelf, \'p\' as picked ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND shelf =?  AND title_id IN (?) ', 
				branchVal, 
				rack,
				category,
				shelf,
				picked_title_ids
				])
	else
		assigned_titles = IbAssignment.find(:all, :select => 'distinct title_id, rack, category, shelf, \'p\' as picked ', :conditions => ['book_branch_id = ? AND rack = ? AND category = ? AND shelf =?', 
				branchVal, 
				rack,
				category,
				shelf
				])
		assigned_titles.each do |t|
			if picked_title_ids.index(t.title_id).nil?
				t.picked = "u"
			end
		end
		return assigned_titles
	end
end

  def self.countAll(params)
      Ibtr.count(:all, :conditions => ['state=? AND respondent_id = ? ', 'Assigned', params[:branchVal]])
      #Ibtr.count(:all,  :conditions => ['state= ? and respondent_id = ? ', 'Assigned',params[:branchVal]])
  end
  
  def self.countPicked(params)
    
    IbtHiddenReq.count(:all, :conditions => ['respondent_id = ? ',  params[:branchVal]])
    
  end
  
  def self.countUnpicked(params)
    
    unpicked_count = IbAssignment.countAll(params) - IbAssignment.countPicked(params)
    unpicked_count
  end
end
