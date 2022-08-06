class Employee
  include Mongoid::Document

  field :name, type: String
  field :salary, type: Float
  field :currency, type: String
  field :department, type: String
  field :sub_department, type: String
  field :on_contract, type: Boolean

  validates_presence_of :name, :salary, :department, :sub_department

  def self.summary_statistics
    ss = Employee.collection.aggregate([
      { "$group": { _id: nil,
          max: { "$max": "$salary" },
          min: { "$min": "$salary" },
          mean: { "$avg": "$salary" }
        }
      }]
      ).first

      if ss.nil?
        {
          max: 0,
          min: 0,
          mean: 0,
        }
      else
        ss
      end
  end

  def self.summary_statistics_on_contract
    ss = Employee.collection.aggregate([
      {
        "$match": {
          on_contract: {"$eq": true}
        }
      },
      { "$group": { _id: nil,
          max: { "$max": "$salary" },
          min: { "$min": "$salary" },
          mean: { "$avg": "$salary" }
        }
      }]
      ).first
      
    if ss.nil?
      {
        max: 0,
        min: 0,
        mean: 0,
      }
    else
      ss
    end
  end

  def self.summary_statistics_department(department)
    ss = Employee.collection.aggregate([
      {
        "$match": {
          department: {"$eq": department},
        }
      },
      { "$group": { _id: nil,
          max: { "$max": "$salary" },
          min: { "$min": "$salary" },
          mean: { "$avg": "$salary" }
        }
      }]
      ).first
      
    if ss.nil?
      {
        max: 0,
        min: 0,
        mean: 0,
      }
    else
      ss
    end
  end

  def self.summary_statistics_department_and_sub_department(department, sub_department)
    ss = Employee.collection.aggregate([
      {
        "$match": {
          department: {"$eq": department},
          sub_department: {"$eq": sub_department},
        }
      },
      { "$group": { _id: nil,
          max: { "$max": "$salary" },
          min: { "$min": "$salary" },
          mean: { "$avg": "$salary" }
        }
      }]
      ).first
      
    if ss.nil?
      {
        max: 0,
        min: 0,
        mean: 0,
      }
    else
      ss
    end
  end
end
