class Branch < ActiveRecord::Base
  has_many :satellites, :foreign_key => "parent_id", :class_name => "Branch"
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Branch"
  has_one :owner,  :class_name => "Franchise"
  def self.branch_id_from_subdomain(subdomain)
    # replace this by searching for a parent branch with subdomain set in the short name
    # TODO
    subdomainbranch = Branch.find_by_subdomain_and_category(subdomain.downcase,['P','W'])
    id = subdomainbranch.id
    id
  end
  
  def self.branch_name_from_subdomain(subdomain)
    find(branch_id_from_subdomain(subdomain)).name
  end
  
  def self.branch_from_subdomain(subdomain)
    find(branch_id_from_subdomain(subdomain))
  end
  
  def self.associate_branches(subdomain)
    branch_id = branch_id_from_subdomain(subdomain)
    if branch_id == 801
      find(:all, :conditions => ['parent_id = ? or category IN(?)', branch_id, ['H','W','T']])
    else
      find(:all, :conditions => ['parent_id = ?', branch_id])
    end
  end
  
  def self.strata_branches 
    find(:all, :conditions => ['parent_id = ? or category IN(?)', branch_id, ['H','W','T']])
  end

end
