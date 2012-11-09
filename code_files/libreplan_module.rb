module Libreplan
  def extract_emp_list(url,auth_hash)
    emp_resorce_info = ''
    emp_resorce_info << open(url, auth_hash){ |f| f.read }
    xml_doc_resorce = Document.new(emp_resorce_info)
    worker_id_list = XPath.match(xml_doc_resorce, '//worker').map{ |worker| worker.attributes['code'] }   
    return worker_id_list  
  end
end