module BillsHelper

  def datetime_modifier(obj)
    obj.strftime('%d-%b-%Y')
  end
end
