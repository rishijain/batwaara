module BillsHelper

  def datetime_modifier(obj)
    obj.strftime('%d-%b-%Y')
  end

  def class_for_settlement(bill)
    bill.event_id == Event.find_by(name: 'Settlement').id ? 'settlement_block' : ''
  end

  def class_for_unsettle_block(bill)
    bill.event_id != Event.find_by(name: 'Settlement').id ? 'not_settlement_block' : ''
  end

  def is_bill_settlement?(bill)
    bill.event_name == 'Settlement'
  end
end
