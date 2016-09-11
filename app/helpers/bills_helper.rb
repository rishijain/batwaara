module BillsHelper

  def datetime_modifier(obj)
    obj.strftime('%d-%b-%Y')
  end

  def is_bill_settlement?(bill)
    bill.event_is_settlement?
  end
end
