module RunLinkable
  extend ActiveSupport::Concern

  protected

  def link_to_run
    unless run_id || job_number.blank? || run_number.blank?
      job = Job.fuzzy_find(job_number) unless job_number.blank?
      job ||= Job.create!(name: job_number.strip) unless job_number.blank?
      update_client(job)

      run = find_run!(job)
      update_rig(run)
      update_well(run)
      update_attributes run_id: run.id if run
    end

    true
  end

  private

  def update_client(job)
    client = job.client if job
    client ||= Client.fuzzy_find(client_name) unless client_name.blank?
    if !client && !client_name.blank?
      client = Client.create!(name: client_name.strip)
    end

    if job
      job.update_attributes client: client unless job.client
    end
  end

  def update_rig(run)
    if run
      rig = Rig.fuzzy_find(rig_name) unless rig_name.blank?
      if !rig && !rig_name.blank?
        rig = Rig.create!(name: rig_name.strip)
      end

      run.update_attributes rig_id: rig.id if rig && !run.rig
    end
  end

  def update_well(run)
    if run
      well = Well.fuzzy_find(well_name) unless well_name.blank?
      if !well && !well_name.blank?
        well = Well.create!(name: well_name.strip)
      end

      run.update_attributes well_id: well.id if well && !run.well
    end
  end

  def find_run!(job)
    if job && !run_number.blank?
      run = Run.find_by("number = ? and job_id = ?", run_number, job.id)
      if run_number.try(:to_i) >= 0
        run ||= Run.create!(number: run_number, job_id: job.id)
      end
    end
  end
end
